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
    
    class Book: Comparable, Identifiable, ObservableObject, Hashable {
        var id: Int
        @Published var title: String
        @Published var authors: [String]
        @Published var position: Int
        @Published var seriesId: Int?
        @Published var tags: [String]
        
        func withAuthors(by main: String) -> String {
            // returns a list of who else wrote a book in addition to the parameter
            var names: [String] = []
            for (_, author) in self.authors.enumerated() {
                if author != main {
                    names.append(author)
                }
            }
            var withNames = ""
            for (i, name) in names.enumerated() {
                if withNames == "" {
                    withNames += "with "
                } else if i == names.count - 1 {
                    withNames += " & "
                } else if i < names.count - 1 {
                    withNames += ", "
                }
                withNames += name
            }
            return withNames
        }

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
        // conform to Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        // init
        init(id: Int, title: String, authors: [String], position: Int = 1, seriesId: Int? = nil, tags: [String] = []) {
            self.id = id
            self.title = title
            self.authors = authors
            self.position = position
            self.seriesId = seriesId
            self.tags = tags
        }
        // init
        init(book: Book) {
            self.id = book.id
            self.title = book.title
            self.authors = book.authors
            self.position = book.position
            self.seriesId = book.seriesId
            self.tags = book.tags
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
                position: item.position_in_series ?? 1,
                seriesId: item.series,
                tags: item.tags
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
        let tags: [String]
    }
}
