//
//  User.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import Foundation

final class User: ObservableObject {
    //    @Published static var current: User!
    
    @Published var username: String?
    @Published var token: String?
    
    init(username: String?, token: String?) {
        self.username = username
        self.token = token
    }
    
    init() {
        self.username = nil
        self.token = nil
    }
}
