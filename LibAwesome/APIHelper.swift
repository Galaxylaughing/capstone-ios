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
    
    // USER - POST/TOKEN
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
    
    // USER - POST/CREATE
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
    
    // BOOK - GET ALL
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
    
    // BOOK - POST/CREATE
    static func postBook(
        token: String?,
        title: String,
        authors: [String],
        position: Int? = nil,
        seriesId: Int? = nil) -> [String:String] {
        
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
        
        // set body
        let book = BookListService.Book(id: 0, title: title, authors: authors, position_in_series: position, series: seriesId)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(book) {
            print(String(data: jsonData, encoding: .utf8)!)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
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
            
        } else {
            print("error occurred during JSON encoding")
            return ["error": "Could not encode object to JSON"]
        }
    }
    
    // BOOK - DELETE
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
    
    // BOOK - PUT/UPDATE
    static func putBook(token: String?, bookId: Int, title: String, authors: [String]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // prepare URL
        let url = URL(string: API_HOST+"books/\(bookId)/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object
        
        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        // set content-type, which PUT/PATCH requires
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //TODO:
        
        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        // set body
        let book = BookListService.Book(id: bookId, title: title, authors: authors, position_in_series: nil, series: nil)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(book) {
            print(String(data: jsonData, encoding: .utf8)!)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
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
            
        } else {
            print("error occurred during JSON encoding")
            return ["error": "Could not encode object to JSON"]
        }
    }
    
    // SERIES - GET ALL
    static func getSeries(token: String?) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"series/")
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
    
    // SERIES - POST/CREATE
    static func postSeries(token: String?, name: String, plannedCount: Int, books: [Int]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // prepare URL
        let url = URL(string: API_HOST+"series/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object
        
        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        // set body
        let series = SeriesListService.Series(id: 0, name: name, planned_count: plannedCount, books: books)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(series) {
            print(String(data: jsonData, encoding: .utf8)!)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
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
                    print("Error took place: \(httpResponse.statusCode) Invalid series parameters")
                    returnData = ["error": "Invalid series information"]
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
            
        } else {
            print("error occurred during JSON encoding")
            return ["error": "Could not encode object to JSON"]
        }
    }
    
}
