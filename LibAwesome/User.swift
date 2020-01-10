//
//  User.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import Foundation

final class User: ObservableObject {    
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
    
    init(user: User) {
        self.username = user.username
        self.token = user.token
    }
}
