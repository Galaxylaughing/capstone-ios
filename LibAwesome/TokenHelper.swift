//
//  TokenHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct TokenHelper {
    static func getToken(json: Data) -> String? {
        // create a token variable
        var token: String?
        
        // create a decoder
        let decoder = JSONDecoder()
        
        // create an object to match the JSON structure
        struct TokenService: Decodable {
            let token: String
        }
        
        // decode the JSON into the object
        if let tokenService = try? decoder.decode(TokenService.self, from: json) {
            // map object-ified JSON to goal object
            token = tokenService.token
        }
        
        return token
    }
}
