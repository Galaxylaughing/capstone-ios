//
//  ISBNHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct ISBNHelper {
    static func cleanIsbn(isbn: String) -> String {
        Debug.debug(msg: "given isbn: \(isbn)", level: .verbose)
        
        var cleanIsbn = ""
        // strip hyphens from isbn
        cleanIsbn = isbn.replacingOccurrences(of: "-", with: "")
        // strip whitespaces from isbn
        cleanIsbn = cleanIsbn.replacingOccurrences(of: " ", with: "")
        
        Debug.debug(msg: "transformed isbn into: \(cleanIsbn)", level: .verbose)
        return cleanIsbn
    }
    
    static func addWithIsbn(isbn: String, env: Env) -> [String:String] {
        // return unknown error if no other code overwrites with the correct error or success message
        var returnData: [String:String] = ["error": "unknown error"]
        
        // strip any whitespace or hyphens from isbn
        let cleanIsbn = ISBNHelper.cleanIsbn(isbn: isbn)
        
        // get book from Google Books API
        guard let googleBookList = GoogleBooksHelper.getFromGoogle(isbn: cleanIsbn) else {
            Debug.debug(msg: "Could not parse Google Books API response into object", level: .error)
            returnData = ["error": "ISBN Not Found"]
            return returnData
        }
        
        // POST book to API
        let googleBook = googleBookList.books[0]
        let bookToSend: BookListService.Book = BookListService.Book(
            id: 0,
            title: googleBook.title,
            authors: googleBook.authors,
            position_in_series: nil,
            series: nil,
            publisher: googleBook.publisher,
            publication_date: googleBook.publicationDate,
            isbn_10: googleBook.isbn10,
            isbn_13: googleBook.isbn13,
            page_count: googleBook.pageCount,
            description: googleBook.description,
            current_status: nil, // replaced by default in initializer
            current_status_date: nil, // replaced by default in initializer
            rating: 0,
            tags: [])
        let response = APIHelper.postBook(
            token: env.user.token,
            book: bookToSend)
        
        if response["success"] != nil {
            print("came back from POSTING with success")
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                let bookList = env.bookList
                bookList.books.append(newBook)
                Env.setEnv(in: env, to: bookList)
                DispatchQueue.main.async {
                    env.book = newBook
                }
                returnData = ["success": "\(newBook.title) was successfully created"]
                return returnData
            }
        } else if response["error"] != nil {
            returnData = ["error": "\(response["error"]!)"]
            return returnData
        }
        
        return returnData
    }
}
