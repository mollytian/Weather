//
//  Temperature.swift
//  Weather
//
//  Created by Molly Tian on 8/21/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import Foundation

struct Temperature {
    let kelvinDegrees: Double
    
    var fahrenheitDegrees: String {
        get {
            return String(kelvinToFahrenheit(kelvinDegrees)) + "℉"
        }
    }
    
    var celsiusDegrees: String {
        get {
            return String(kelvinToCelsius(kelvinDegrees)) + "℃"
        }
    }
   
    
    func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }

}
