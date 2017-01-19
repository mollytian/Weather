//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Molly Tian on 8/20/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var city: City?
    var weather: Weather? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highestTemperatureLabel: UILabel!
    @IBOutlet weak var lowestTemperatureLabel: UILabel!
    
    // MARK: - Service
    var weatherService: WeatherServiceProtocol!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateUI()
        
        if weather == nil && city != nil{
            weatherService.fetchWeatherInfo(city!.zipCode) { (weather, error) in
                DispatchQueue.main.async {
                    self.weather = weather
                }
                
            }
        }
        
    }
    
    func updateUI() {
        currentTemperatureLabel?.text = weather?.temperature.fahrenheitDegrees
        descriptionLabel?.text = weather?.description.capitalizingFirstLetter()
        if let highestTemp = weather?.details["temp_max"] {
            highestTemperatureLabel?.text = Temperature(kelvinDegrees: highestTemp).fahrenheitDegrees
        }
        if let lowestTemp = weather?.details["temp_min"] {
            lowestTemperatureLabel?.text = Temperature(kelvinDegrees: lowestTemp).fahrenheitDegrees
        }
        title = weather?.city
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}
