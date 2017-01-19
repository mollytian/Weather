//
//  Weather.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import Foundation

struct Weather {
    
    let description: String            // weahter description
    let main: String                   // main weather information
    let city: String                   // city
    let temperature: Temperature       // temperature
    let details: [String:Double]       // weather details
    let iconText: String               // icon id, used to fetch the icon from network
}
