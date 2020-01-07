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
        @Published var authors: [String]
        @Published var position: Int?
        @Published var seriesId: Int?
        
        func authorNames() -> String {
            var names = ""
            for (i, author) in self.authors.enumerated() {
                names += author
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
        init(id: Int, title: String, authors: [String], position: Int? = nil, seriesId: Int? = nil) {
            self.id = id
            self.title = title
            self.authors = authors
            self.position = position
            self.seriesId = seriesId
        }
        // init
        init(book: Book) {
            self.id = book.id
            self.title = book.title
            self.authors = book.authors
            self.position = book.position
            self.seriesId = book.seriesId
        }

    }
    
    init(bookList: BookList) {
        self.books = bookList.books
    }
    
    init(books: [Book]) {
        self.books = books
    }
    
    init(from service: BookListService) {
        books = []
        
        let items = service.books
        for item in items {
            
            var authors: [String] = []
            for authorName in item.authors {
                let author = authorName
                authors.append(author)
            }
            
            let book = BookList.Book(
                id: item.id,
                title: item.title,
                authors: authors,
                position: item.position_in_series,
                seriesId: item.series
            )
            
            books.append(book)
        }
    }
}

// an object to match the JSON structure
struct BookListService: Decodable {
    let books: [Book]
    
    struct Book: Codable {
        let id: Int
        let title: String
        let authors: [String]
        let position_in_series: Int?
        let series: Int?
    }
}
