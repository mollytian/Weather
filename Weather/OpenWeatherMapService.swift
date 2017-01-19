//
//  OpenWeatherMapService.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit
import SwiftyJSON

struct OpenWeatherMapService: WeatherServiceProtocol{
    
    fileprivate let apiKey: String
    
    init() {
        // get appId from Info.plist
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let parameters = NSDictionary(contentsOfFile:filePath)
        apiKey = (parameters!["OpenWeatherAPIKey"]! as AnyObject).description
    }
    

    fileprivate let weatherDataUrlPath = "http://api.openweathermap.org/data/2.5/weather?"`
    fileprivate let defualtSession = URLSession(configuration: URLSessionConfiguration.default)
    
    fileprivate func generateRequestURL(_ zipCode: String) -> URL? {
        
        guard let components = URLComponents(string:weatherDataUrlPath) else {
            return nil
        }
        
        components.queryItems = [URLQueryItem(name:"zip", value:zipCode + ",us"),
                                 URLQueryItem(name:"appid", value:apiKey)]
        
        return components.url
    }
    
    // MARK: - APIs
    
    func fetchWeatherInfo(_ zipCode: String, completionHandler: @escaping WeatherCompletionHandler) {
        guard let url = generateRequestURL(zipCode) else {
            let error = Error(errorCode: .urlError)
            completionHandler(nil, error)
            return
        }
        
        //print(url)
        let request = URLRequest(url: url)
        let task = defualtSession.dataTask(with: request,
                                               completionHandler: { data, response, networkError in
                                                
                                                // Check network error
                                                guard networkError == nil else {
                                                    let error = Error(errorCode: .networkRequestFailed)
                                                    completionHandler(nil, error)
                                                    return
                                                }
                                                
                                                // Check JSON serialization error
                                                guard let unwrappedData = data else {
                                                    let error = Error(errorCode: .jsonSerializationFailed)
                                                    completionHandler(nil, error)
                                                    return
                                                }
                                                
                                                let json = JSON(data: unwrappedData)
                                                guard let icon = json["weather"][0]["icon"].string,
                                                    let main = json["weather"][0]["main"].string,
                                                    let description = json["weather"][0]["description"].string,
                                                    let city = json["name"].string,
                                                    let temperature = json["main"]["temp"].double,
                                                let details = json["main"].dictionaryObject as? [String:Double]
                                                
                                                else {
                                                    let error = Error(errorCode: .jsonParsingFailed)
                                                    completionHandler(nil, error)
                                                    return
                                                }
                                                
                                                let weather = Weather(description: description, main: main, city: city, temperature: Temperature(kelvinDegrees: temperature), details:details,iconText: icon)
                                                completionHandler(weather, nil)

        })
        
        task.resume()
    }
    
    func fetchWeatherIcon(_ id: String, completionHandler: @escaping (_ image: UIImage?) -> Void ) {
        let urlString = "http://openweathermap.org/img/w/" + id + ".png"
        let request = URLRequest(url: URL(string: urlString )!)
        let task = defualtSession.dataTask(with: request, completionHandler: {data, response, error in
            // Check network error
            guard error == nil else {
                print(error?.description)
                completionHandler(nil)
                return
            }
            
            if let image = UIImage(data: data!) {
                completionHandler(image)
            }
        })
        task.resume()
        
        
    }
    
    func weatherIconURL(_ id: String) -> URL? {
        let urlString = "http://openweathermap.org/img/w/" + id + ".png"
        return URL(string: urlString)
    }
    
    

    
}
