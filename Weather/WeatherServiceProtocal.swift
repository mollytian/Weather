//
//  WeatherServiceProtocal.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//


import UIKit

typealias WeatherCompletionHandler = (Weather?, Error?) -> Void

protocol WeatherServiceProtocol {
    func fetchWeatherInfo(_ zipCode: String, completionHandler: WeatherCompletionHandler)
    func fetchWeatherIcon(_ id: String, completionHandler:(_ image: UIImage?) -> Void )
    func weatherIconURL(_ id: String) -> URL?
}
