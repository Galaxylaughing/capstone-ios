//
//  Debug.swift
//  LibAwesome
//
//  Created by Sabrina on 1/10/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

enum DebugLevel: Int {
    case verbose = 0
    case debug   = 10
    case warn    = 20
    case error   = 30
}

class Debug {
    static var debugLevel: DebugLevel = .debug // set to the debug level for the app
    
    // call to optionally print a debug message based on the level of the message and the current debug level
    static func debug(msg message: String, level: DebugLevel = .verbose) {
        if (level.rawValue >= debugLevel.rawValue) {
            print(message)
        }
    }
}
