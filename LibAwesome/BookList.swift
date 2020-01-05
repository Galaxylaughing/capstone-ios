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
    
    class Book: Comparable, Identifiable, ObservableObject {
        var id: Int
        @Published var title: String
        @Published var authors: [Author]
        
        struct Author {
            var name: String
        }
        
        func authorNames() -> String {
            var names = ""
            for (i, author) in self.authors.enumerated() {
                names += author.name
                if i == self.authors.count - 2 {
                    names += " & "
                } else if i < self.authors.count - 2 {
                    names += ", "
                }
            }
            return names
        }
        
        func findComponents() -> [String] {
            return self.title.components(separatedBy: ": ")
        }
        
        func getMainTitle() -> String {
            return findComponents()[0]
        }
        
        // conform to Comparable
        static func < (lhs: Book, rhs: Book) -> Bool {
            return lhs.title < rhs.title
        }
        static func == (lhs: Book, rhs: Book) -> Bool {
            return lhs.title == rhs.title
        }
        
        // init
        init(id: Int, title: String, authors: [BookList.Book.Author]) {
            self.id = id
            self.title = title
            self.authors = authors
        }
        
    }
    
    init(books: [Book]) {
        self.books = books
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
                id: item.id,
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
        let id: Int
        let title: String
        let authors: [String]
    }
}
