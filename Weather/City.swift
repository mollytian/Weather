//
//  City.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import Foundation

struct City {
    var name: String
    var zipCode: String
    
    init(name: String, zipCode: String) {
        self.name = name
        self.zipCode = zipCode
    }
}
