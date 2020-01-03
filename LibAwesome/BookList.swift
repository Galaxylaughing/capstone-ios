//
//  BookList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class BookList: ObservableObject {
    @Published var books: [Book]
    
    struct Book {
        var title: String
        var authors: [Author]
        
        struct Author {
            var name: String
        }
    }
        
    init(from service: BookListService) {
        books = []
        
        let items = service.books
        for item in items {
    
            var authors: [BookList.Book.Author] = []
            for authorName in item.authors {
                let author = BookList.Book.Author(name: authorName)
                authors.append(author)
            }
            
            let book = BookList.Book(
                title: item.title,
                authors: authors
            )
            
            books.append(book)
        }
    }
}

// an object to match the JSON structure
struct BookListService: Decodable {
    let books: [Book]
    
    struct Book: Decodable {
        let title: String
        let authors: [String]
    }
}
