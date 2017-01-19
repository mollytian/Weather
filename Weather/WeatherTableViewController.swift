//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    // MARK: - Properties

    var cities = [City]()
    
    // MARK: - Constants
    fileprivate struct Storyboard {
        static let WeatherCellIdentifier = "WeatherCell"
        static let WeatherDetailViewSegueIdentifier = "WeatherDetail"
    }
    
    // MARK: - Service
    var weatherService: WeatherServiceProtocol!
    
    // MARK: - Custom Functions
    
    @IBAction func addAZipcode(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add a Zip Code",
                                      message: "Please enter the zip code",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel",
            style: .cancel,
            handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "Add",
            style: .default,
            handler: { (action) in
                if let tf = alert.textFields?.first {
                    let newCity = City(name: "", zipCode: tf.text!)
                    self.cities.append(newCity)
                    let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                    self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.right)
                    
                    // segue to the detail page after 0.2s
                    let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        self.performSegue(withIdentifier: Storyboard.WeatherDetailViewSegueIdentifier, sender:self.tableView.cellForRow(at: indexPath))
                    }
                }
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "Zip Code"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alert.view.setNeedsLayout()
        present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - ViewController Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // used autolayout in tableView cell, set those two parameters to use self-sizing table view cells
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        // load pre-populated zip codes
        let filePath = Bundle.main.path(forResource: "Preload", ofType: "plist")!
        let parameters = NSDictionary(contentsOfFile:filePath)
        if let dict = parameters!["SavedCities"]! as? [String:String] {
        
        var savedCities = [City]()
        for (key, value) in dict {
            savedCities.append(City(name: key, zipCode: value))
        }
            cities = savedCities
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.WeatherCellIdentifier, for: indexPath)
        
        let city = cities[(indexPath as NSIndexPath).row]
        
        if let weatherCell = cell as? WeatherTableViewCell {
            weatherCell.city = city
            
            weatherService.fetchWeatherInfo(city.zipCode) { (weather, error) in
                DispatchQueue.main.async {
                    weatherCell.weather = weather
                    if let icon = weather?.iconText {
                        if let url = self.weatherService.weatherIconURL(icon){
                            weatherCell.weatherIcon.af_setImageWithURL(url)
                        }
                    }
                }
            }
            
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            cities.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.WeatherDetailViewSegueIdentifier {
            if let weatherDetailVC = segue.destination as? WeatherDetailViewController,
            let cell = sender as? WeatherTableViewCell {
                weatherDetailVC.weatherService = weatherService
                weatherDetailVC.weather = cell.weather
                weatherDetailVC.city = cell.city
                weatherDetailVC.title = cell.city?.name
            }
        }
    }
    

}
