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

    // parsing JSON example: https://dev.to/jaumevn/parsing-json-with-swift-5-2m40
    static func decode(str: String) -> BookList? {
        print("I'M DECODING THIS:")
        print(str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceBookList = try? decoder.decode(BookListService.self, from: data!) {
            print("\nI DECODED SUCCESSFULLY INTO SERVICE:")
            print(serviceBookList)
            // map object-ified JSON to goal object
            let bookList = BookList(from: serviceBookList)
            print("\nI DECODED SUCCESSFULLY INTO OBJECT:")
            print(bookList)
            return bookList
        } else {
            print("I FAILED")
        }
        
        print("I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a BookList object
    static func makeBookList(data: String) -> BookList? {
        if let bookList = decode(str: data) {
            print("\nRESULTING BOOKS:")
            for book in bookList.books {
                print(book)
            }
            return bookList
        }
        // else
        print("ERROR")
        return nil
    }
    
}
