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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
            }
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                
                guard let userToken = TokenHelper.getToken(json: data) else {
                    Debug.debug(msg: "Error: invalid username or password", level: .error)
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 403 {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Account already exists", level: .error)
                returnData = ["error": "Username already exists"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                returnData = ["success": "success"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
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
        book: BookListService.Book) -> [String:String] {
        
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
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(book) {
            Debug.debug(msg: String(data: jsonData, encoding: .utf8)!, level: .verbose)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let group = DispatchGroup()
            group.enter()
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer { group.leave() }
                
                // Check for Error
                if let error = error {
                    Debug.debug(msg: "Error took place: \(error)", level: .error)
                    returnData = ["error": "\(error)"]
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    Debug.debug(msg: "Error took place", level: .error)
                    returnData = ["error": "Unknown error communicating with server"]
                    return
                }
                
                if httpResponse.statusCode == 400 {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Invalid book parameters", level: .error)
                    returnData = ["error": "Invalid book information"]
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                    returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    Debug.debug(msg: "Response data string:\n \(dataString)", level: .debug)
                    returnData = ["success": "\(dataString)"]
                }
            }
            task.resume()
            group.wait()
            return returnData
            
        } else {
            Debug.debug(msg: "error occurred during JSON encoding", level: .error)
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 400 {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Could not find book with ID: \(bookId)", level: .error)
                returnData = ["error": "Could not find book with ID: \(bookId)"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    // BOOK - PUT/UPDATE
    static func putBook(
        token: String?,
        bookId: Int,
        book: BookListService.Book) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // prepare URL
        let url = URL(string: API_HOST+"books/\(bookId)/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object
        
        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
        
        // set body
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(book) {
            Debug.debug(msg: String(data: jsonData, encoding: .utf8)!, level: .verbose)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let group = DispatchGroup()
            group.enter()
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer { group.leave() }
                
                // Check for Error
                if let error = error {
                    Debug.debug(msg: "Error took place: \(error)", level: .error)
                    returnData = ["error": "\(error)"]
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    Debug.debug(msg: "Error took place", level: .error)
                    returnData = ["error": "Unknown error communicating with server"]
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                    returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                    returnData = ["success": "\(dataString)"]
                }
            }
            task.resume()
            group.wait()
            
            return returnData
            
        } else {
            Debug.debug(msg: "error occurred during JSON encoding", level: .error)
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                
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
            Debug.debug(msg: String(data: jsonData, encoding: .utf8)!, level: .verbose)
            
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let group = DispatchGroup()
            group.enter()
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer { group.leave() }
                
                // Check for Error
                if let error = error {
                    Debug.debug(msg: "Error took place: \(error)", level: .error)
                    returnData = ["error": "\(error)"]
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    Debug.debug(msg: "Error took place", level: .error)
                    returnData = ["error": "Unknown error communicating with server"]
                    return
                }
                
                if httpResponse.statusCode == 400 {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Invalid series parameters", level: .error)
                    returnData = ["error": "Invalid series information"]
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                    returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                    
                    returnData = ["success": "\(dataString)"]
                }
            }
            task.resume()
            group.wait()
            return returnData
            
        } else {
            Debug.debug(msg: "error occurred during JSON encoding", level: .error)
            return ["error": "Could not encode object to JSON"]
        }
    }
    
    // SERIES - PUT/UPDATE
    static func putSeries(
        token: String?,
        seriesId: Int,
        name: String,
        plannedCount: Int,
        books: [Int]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]

        // prepare URL
        let url = URL(string: API_HOST+"series/\(seriesId)/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object

        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")

        // set body
        let series = SeriesListService.Series(id: seriesId, name: name, planned_count: plannedCount, books: books)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(series) {
            Debug.debug(msg: String(data: jsonData, encoding: .utf8)!, level: .verbose)

            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let group = DispatchGroup()
            group.enter()
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer { group.leave() }

                // Check for Error
                if let error = error {
                    Debug.debug(msg: "Error took place: \(error)", level: .error)
                    returnData = ["error": "\(error)"]
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Debug.debug(msg: "Error took place", level: .error)
                    returnData = ["error": "Unknown error communicating with server"]
                    return
                }

                if !(200...299).contains(httpResponse.statusCode) {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                    returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                    return
                }

                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                    returnData = ["success": "\(dataString)"]
                }
            }
            task.resume()
            group.wait()

            return returnData

        } else {
            Debug.debug(msg: "error occurred during JSON encoding", level: .error)
            return ["error": "Could not encode object to JSON"]
        }
    }
    
    // SERIES - DELETE
    static func deleteSeries(token: String?, seriesId: Int) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"series/\(seriesId)/")
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 400 {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Could not find series with ID: \(seriesId)", level: .error)
                returnData = ["error": "Could not find series with ID: \(seriesId)"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    // TAGS - DELETE
    static func deleteTag(token: String?, tagName: String) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: API_HOST+"tags/\(tagName)/")
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
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if httpResponse.statusCode == 400 {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode) Could not find any tags matching the name '\(tagName)'", level: .error)
                returnData = ["error": "Could not find any \(tagName) tags"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    // TAG - PUT/UPDATE
    static func putTag(
        token: String?,
        tagName: String,
        newTagName: String,
        books: [Int]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]

        // prepare URL
        let url = URL(string: API_HOST+"tags/\(tagName)/")
        guard let requestURL = url else { fatalError() } // unwraps the 'URL?' object

        // prepare request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        // set header
        let value = "Token \(token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")

        // set body
        struct TagToUpdate: Encodable {
            let new_name: String
            let books: [Int]
        }
        let tag = TagToUpdate(new_name: newTagName, books: books)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(tag) {
            Debug.debug(msg: String(data: jsonData, encoding: .utf8)!, level: .verbose)

            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let group = DispatchGroup()
            group.enter()
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer { group.leave() }

                // Check for Error
                if let error = error {
                    Debug.debug(msg: "Error took place: \(error)", level: .error)
                    returnData = ["error": "\(error)"]
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Debug.debug(msg: "Error took place", level: .error)
                    returnData = ["error": "Unknown error communicating with server"]
                    return
                }

                if !(200...299).contains(httpResponse.statusCode) {
                    Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                    returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                    return
                }

                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                    returnData = ["success": "\(dataString)"]
                }
            }
            task.resume()
            group.wait()

            return returnData

        } else {
            Debug.debug(msg: "error occurred during JSON encoding", level: .error)
            return ["error": "Could not encode object to JSON"]
        }
    }
    
    // GOOGLE BOOKS API - ISBN
    //  EX: https://www.googleapis.com/books/v1/volumes?q=isbn:1429967943
    static func getBookByISBN(isbn: String) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        let url = URL(string: GOOGLE_BOOKS+"isbn:"+isbn)
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
    
    // GOOGLE BOOKS API - TITLE/AUTHORS
    // EX: https://www.googleapis.com/books/v1/volumes?q=inauthor:"Gaiman Pratchett"+intitle:"Good Omens"
    static func getBookBySeachTerms(title: String, authors: [String]) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // Prepare URL
        var searchString: String
        if title != "" && authors != [] {
            searchString = "intitle:\"\(title)\"+inauthor:\""
            for (index, author) in authors.enumerated() {
                if index == authors.count - 1 {
                   searchString += "\(author)"
                } else {
                    searchString += "\(author) "
                }
            }
            searchString += "\""
        } else if title != "" {
            searchString = "intitle:\"\(title)\""
        } else if authors != [] {
            searchString = "inauthor:\""
            for (index, author) in authors.enumerated() {
                if index == authors.count - 1 {
                   searchString += "\(author)"
                } else {
                    searchString += "\(author) "
                }
                searchString += "\""
            }
        } else {
            fatalError()
        }
        // percent encode search string
        let percentEncodedString = EncodingHelper.percentEncodeString(string: searchString)
        guard let encoded = percentEncodedString else { fatalError() }
        
        print("ENCODED: \(encoded)")
        
        let urlString = GOOGLE_BOOKS+encoded+"&startIndex=0&maxResults=20" // restricts number of results
        let url = URL(string: urlString)
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object
        Debug.debug(msg: "URL: \(requestUrl)", level: .verbose)
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let group = DispatchGroup()
        group.enter()
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { group.leave() }
            
            // Check for Error
            if let error = error {
                Debug.debug(msg: "Error took place: \(error)", level: .error)
                returnData = ["error": "\(error)"]
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Debug.debug(msg: "Error took place", level: .error)
                returnData = ["error": "Unknown error communicating with server"]
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                Debug.debug(msg: "Error took place: \(httpResponse.statusCode)", level: .error)
                returnData = ["error": "HTTP Response Code: \(httpResponse.statusCode)"]
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Debug.debug(msg: "Response data string:\n \(dataString)", level: .verbose)
                
                returnData = ["success": "\(dataString)"]
            }
        }
        task.resume()
        group.wait()
        return returnData
    }
    
}
