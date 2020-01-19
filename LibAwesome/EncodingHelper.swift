//
//  EncodingHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation
import SwiftUI

struct EncodingHelper {
    // TAG NAMES
    static func encodeTagName(tagName: String) -> String {
        // change all occurrences of '/' delimiter to '__' to send info to API
        return tagName.replacingOccurrences(of: "/", with: "__")
    }
    static func decodeTagName(tagName: String) -> String {
        // change all occurrences of '__' delimiter to '/' to get info from API
        return tagName.replacingOccurrences(of: "__", with: "/")
    }
    
    // PERCENT ENCODE STRINGS
    // from https://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
    static func percentEncodeString(string: String) -> String? {
        let unreserved = "-._~/?:"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return string.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    // TAGS
    static func getTags(from source: BookList) -> TagList {
        let newTagList = TagList(from: source)
        Debug.debug(msg: "\nRESULTING TAGS:", level: .verbose)
        for tag in newTagList.tags {
            Debug.debug(msg: tag.name, level: .verbose)
            for book in tag.books {
                Debug.debug(msg: "-- \(book.title)", level: .verbose)
            }
        }
        return newTagList
    }
    
    // AUTHORS
    static func getAuthors(from source: BookList) -> AuthorList {
        let newAuthorList = AuthorList(from: source)
        Debug.debug(msg: "\nRESULTING AUTHORS:")
        for author in newAuthorList.authors {
            Debug.debug(msg: author.name)
            for book in author.books {
                Debug.debug(msg: "-- \(book.title)")
            }
        }
        return newAuthorList
    }
    
    // BOOKS
    // parsing JSON example: https://dev.to/jaumevn/parsing-json-with-swift-5-2m40
    static func decodeBookList(str: String) -> BookList? {
        Debug.debug(msg: "I'M DECODING THIS:")
        Debug.debug(msg: str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceBookList = try? decoder.decode(BookListService.self, from: data!) {
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO SERVICE:")
            Debug.debug(msg: "\(serviceBookList)")
            // map object-ified JSON to goal object
            let bookList = BookList(from: serviceBookList)
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO OBJECT:")
            Debug.debug(msg: "\(bookList)")
            
            if Debug.debugLevel == .verbose {
                Debug.debug(msg: "\nBOOKLIST CONTENTS:", level: .verbose)
                for book in bookList.books {
                    Debug.debug(msg: "\tBOOK: \t \(book.title)", level: .verbose)
                    Debug.debug(msg: "\t\t\t\t \(book.authorNames())", level: .verbose)
                    Debug.debug(msg: "\t\t\t\t \(book.current_status)", level: .verbose)
                }
            }
            
            return bookList
        } else {
            Debug.debug(msg: "I FAILED in decodeBookList", level: .error)
        }
        
        Debug.debug(msg: "I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a BookList object
    static func makeBookList(data: String) -> BookList? {
        if let bookList = decodeBookList(str: data) {
            Debug.debug(msg: "\nRESULTING BOOKS:")
            for book in bookList.books {
                Debug.debug(msg: "\(book) \(book.title)")
            }
            return bookList
        }
        // else
        Debug.debug(msg: "ERROR")
        return nil
    }
    
    // turn JSON into a Book object
    static func makeBook(data: String) -> BookList.Book? {
        if let bookList = decodeBookList(str: data) {
            Debug.debug(msg: "\nRESULTING BOOK:")
            Debug.debug(msg: "\(bookList.books[0])")
            return bookList.books[0]
        }
        // else
        Debug.debug(msg: "ERROR")
        return nil
    }
    
    
    // SERIES
    static func decodeSeriesList(str: String) -> SeriesList? {
        Debug.debug(msg: "I'M DECODING THIS:")
        Debug.debug(msg: str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceSeriesList = try? decoder.decode(SeriesListService.self, from: data!) {
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO SERVICE:")
            Debug.debug(msg: "\(serviceSeriesList)")
            // map object-ified JSON to goal object
            let seriesList = SeriesList(from: serviceSeriesList)
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO OBJECT:")
            Debug.debug(msg: "\(seriesList)")
            return seriesList
        } else {
            Debug.debug(msg: "I FAILED")
        }
        
        Debug.debug(msg: "I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a SeriesList object
    static func makeSeriesList(data: String) -> SeriesList? {
        if let seriesList = decodeSeriesList(str: data) {
            Debug.debug(msg: "\nRESULTING SERIES:")
            for series in seriesList.series {
                Debug.debug(msg: "\(series) \(series.name)")
            }
            return seriesList
        }
        // else
        Debug.debug(msg: "makeSeriesList encountered an error")
        return nil
    }

    // turn JSON into a Series object
    static func makeSeries(data: String) -> SeriesList.Series? {
        if let seriesList = decodeSeriesList(str: data) {
            Debug.debug(msg: "\nRESULTING Series:")
            Debug.debug(msg: "\(seriesList.series[0])")
            return seriesList.series[0]
        }
        // else
        Debug.debug(msg: "ERROR")
        return nil
    }
    
    // BOOK-STATUS
    static func decodeStatusList(str: String) -> BookStatusList? {
        Debug.debug(msg: "I'M DECODING THIS:", level: .debug)
        Debug.debug(msg: str, level: .debug)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceStatusList = try? decoder.decode(BookStatusListService.self, from: data!) {
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO SERVICE:", level: .verbose)
            Debug.debug(msg: "\(serviceStatusList)", level: .verbose)
            // map object-ified JSON to goal object
            let statusList = BookStatusList(from: serviceStatusList)
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO OBJECT:", level: .verbose)
            Debug.debug(msg: "\(statusList)", level: .verbose)
            return statusList
        } else {
            Debug.debug(msg: "I FAILED", level: .error)
        }
        
        Debug.debug(msg: "I'M ABOUT TO RETURN", level: .verbose)
        return nil
    }
    
    // turn JSON into a BookStatusList object
    static func makeStatusList(data: String) -> BookStatusList? {
        if let statusList = decodeStatusList(str: data) {
            Debug.debug(msg: "\nRESULTING STATUS:", level: .debug)
            for status in statusList.status_history {
                Debug.debug(msg: "\(status) \(status.status.getHumanReadableStatus())", level: .debug)
            }
            return statusList
        }
        // else
        Debug.debug(msg: "makeStatusList encountered an error", level: .error)
        return nil
    }
    
    // decode delete-book-status response
    struct DeletedStatusService: Decodable {
        let status: DeletedBookStatus
        let current_status: String
        let current_status_date: String
        
        struct DeletedBookStatus: Decodable {
            var id: Int
            var status_code: String
            var date: String
            let book: Int
        }
    }
    class NewCurrentStatusInfo {
        var current_status: Status
        var current_status_date: Date
        
        init(currentStatus: Status, currentStatusDate: Date) {
            self.current_status = currentStatus
            self.current_status_date = currentStatusDate
        }
    }
    static func decodeDeletedStatusData(str: String) -> NewCurrentStatusInfo? {
        Debug.debug(msg: "I'M DECODING THIS:", level: .debug)
        Debug.debug(msg: str, level: .debug)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let deletedStatusService = try? decoder.decode(DeletedStatusService.self, from: data!) {
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO SERVICE:", level: .debug)
            Debug.debug(msg: "\(deletedStatusService)", level: .debug)
                
            let formatter = ISO8601DateFormatter()
            let isoDate = formatter.date(from: deletedStatusService.current_status_date)
            
            let newCurrentStatusInfo = NewCurrentStatusInfo(
                currentStatus: Status(rawValue: deletedStatusService.current_status) ?? Status.wanttoread,
                currentStatusDate: isoDate ?? Date()
            )
            
            Debug.debug(msg: "\nI DECODED SUCCESSFULLY INTO OBJECT:", level: .debug)
            Debug.debug(msg: "\(newCurrentStatusInfo)", level: .debug)
            return newCurrentStatusInfo
            
        } else {
            Debug.debug(msg: "I FAILED TO DECODE SERVICE", level: .error)
        }
        
        Debug.debug(msg: "I'M ABOUT TO RETURN", level: .verbose)
        return nil
    }
    
}
