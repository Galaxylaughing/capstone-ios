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
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
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
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    static func signupUser(username: String, password: String) -> [String:String] {
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
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 403 {
                print("Error took place: \(httpResponse.statusCode) Account already exists")
                returnData = ["error": "Username already exists"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "success"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    /*
    static func logout(token: String?) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"logout/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        //Prepare HTTP Request Header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                returnData = ["error": "\(error)"]
                return
            }
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    */
    
    static func getBooks(token: String?) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"books/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        //Prepare HTTP Request Header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                returnData = ["error": "\(error)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    static func postBook(token: String?, title: String, authors: [String]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // prepare URL
        let url = URL(string: API_HOST+"books/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object
        
        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        // request parameters
        var postString = "title=\(title)"
        for author in authors {
            postString.append("&author=\(author)")
        }
        // request body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                
                returnData = ["error": "\(error)"]
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 400 {
                print("Error took place: \(httpResponse.statusCode) Invalid book parameters")
                returnData = ["error": "Invalid book information"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        
        return returnData
    }
    
    static func deleteBook(token: String?, bookId: Int) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"books/\(bookId)/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
        //Prepare HTTP Request Header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 400 {
                print("Error took place: \(httpResponse.statusCode) No book found with the ID \(bookId)")
                returnData = ["error": "No book found with the ID \(bookId)"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    static func patchBook(token: String?, bookId: Int, title: String, authors: [String]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // prepare URL
        let url = URL(string: API_HOST+"books/\(bookId)/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object
        
        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        // set content-type, which PUT/PATCH requires
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        // request parameters
        var postString = "title=\(title)"
        for author in authors {
            postString.append("&author=\(author)")
        }
        // request body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        print("SENDING BODY", postString)
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                returnData = ["error": "\(error)"]
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        
        return returnData
    }
    
}
