//
//  User.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import Foundation

struct User: Codable {
    static var current:User!
    
    var id: String
    var username: String
}
