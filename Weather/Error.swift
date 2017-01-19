//
//  Error.swift
//  Weather
//
//  Created by Molly Tian on 8/19/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import Foundation

struct Error {
    enum Code: Int {
        case urlError                 = -6000
        case networkRequestFailed     = -6001
        case jsonSerializationFailed  = -6002
        case jsonParsingFailed        = -6003
    }
    
    let errorCode: Code
}
