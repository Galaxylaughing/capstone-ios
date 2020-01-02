//
//  APIHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation
import SwiftUI

struct APIHelper {
    
    // POST syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    static func loginUser(username: String, password: String) -> [String:String] {
        let group = DispatchGroup()
        group.enter()
        
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"auth-token/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Prepare HTTP Request Parameters
        let postString = "username=\(username)&password=\(password)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                
                returnData = ["error": "\(error)"]
            }
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                guard let userToken = TokenHelper.getToken(json: data) else {
                    returnData = ["error": "Invalid username or password"]
                    return
                }
                
                returnData = ["success": "\(userToken)"]
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    static func signupUser(username: String, password: String) -> [String:String] {
        let group = DispatchGroup()
        group.enter()
        
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"signup/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // Prepare HTTP Request Parameters
        let postString = "username=\(username)&password=\(password)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                
//                self.error = ErrorAlert(reason: "\(error)")
                returnData = ["error": "\(error)"]
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
//                self.error = ErrorAlert(reason: "Unknown error communicating with server")
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 403 {
                print("Error took place: \(httpResponse.statusCode) Account already exists")
//                self.error = ErrorAlert(reason: "Username already exists")
                returnData = ["error": "Username already exists"]
                return
            }

            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
//                self.error = ErrorAlert(reason: "\(httpResponse.statusCode)")
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "success"]
                
                /*
                // set signup success message
                self.signupSuccess = true
                // take user back to login page
                self.showSignUp = false
                */
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return returnData
    }
    
}
