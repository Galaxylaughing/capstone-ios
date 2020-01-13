//
//  GoogleBooksHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct GoogleBooksHelper {
    static func decodeGoogleBook(json: String) -> BookList? {
        let data = Data(json.utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceGoogleBookList = try? decoder.decode(GoogleBookListService.self, from: data) {
            // map object-ified JSON to object
            let bookList = BookList(from: serviceGoogleBookList)
            
            // print the results
            Debug.debug(msg: """
                Successfully parsed Google Books API response,
                received: \(bookList) with \(bookList.books.count) books
                """,                                                                    level: .debug)
            let allBooks = bookList.books
            for book in allBooks {
                Debug.debug(msg: "\n\tBOOK: ",                                          level: .debug)
                Debug.debug(msg: "title:  \(book.title)",                               level: .debug)
                Debug.debug(msg: "authors: ",                                           level: .debug)
                for author in book.authors {
                    Debug.debug(msg: "\t\(author)",                                     level: .debug)
                }
                Debug.debug(msg: "isbn-10:  \(book.isbn10 ?? "none")",                  level: .debug)
                Debug.debug(msg: "isbn-13:  \(book.isbn13 ?? "none")",                  level: .debug)
                Debug.debug(msg: "publisher: \(book.publisher ?? "none")",              level: .debug)
                Debug.debug(msg: "publication date: \(book.publicationDate ?? "none")", level: .debug)
                Debug.debug(msg: "page count: \(book.pageCount ?? 0)",                  level: .debug)
                Debug.debug(msg: "description: \(book.description ?? "none")",          level: .debug)
            }
            
            return bookList
        }
        return nil
    }
    
    static func getFromGoogle(isbn: String) -> BookList? {
        let response = APIHelper.getBookByISBN(isbn: isbn)
        
        if response["success"] != nil {
            Debug.debug(msg: "Received success response from Google Books API", level: .verbose)
            if let decodedGoogleBook = GoogleBooksHelper.decodeGoogleBook(json: response["success"]!) {
                return decodedGoogleBook
            }
        }
        return nil
    }
}
