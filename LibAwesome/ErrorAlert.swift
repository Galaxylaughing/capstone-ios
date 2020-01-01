//
//  ErrorAlert.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import Foundation

struct ErrorAlert: Identifiable {
    var id: String {
        return reason
    }
    
    let reason: String
}
