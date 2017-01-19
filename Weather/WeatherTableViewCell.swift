//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit
import AlamofireImage

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - Service
    var weatherService: WeatherServiceProtocol!
    
    var city: City? {
        didSet {
            updateUI(withCity: city)
        }
    }
    
    var weather: Weather? {
        didSet {
            updateUI(withWeather: weather)
        }
    }
    
    
    
    fileprivate func updateUI(withCity city: City?) {
        
        // reset any existing information
        cityNameLabel?.text = nil
        zipCodeLabel?.text = nil
        
        // load new information from city
        cityNameLabel?.text = city?.name
        zipCodeLabel?.text = city?.zipCode
    }
    
    fileprivate func updateUI(withWeather weather: Weather?) {
        temperatureLabel?.text = nil
        weatherIcon?.image = nil
        
        temperatureLabel.text = weather?.temperature.fahrenheitDegrees
        if let cityName = weather?.city {
            city?.name = cityName
        }
    }
}
