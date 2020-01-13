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
        @Published var publisher: String?
        @Published var publicationDate: String?
        @Published var isbn10: String?
        @Published var isbn13: String?
        @Published var pageCount: Int?
        @Published var description: String?
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
        
        init() {
            self.id = 0
            self.title = ""
            self.authors = []
            self.position = 0
            self.seriesId = nil
            self.publisher = nil
            self.publicationDate = nil
            self.isbn10 = nil
            self.isbn13 = nil
            self.pageCount = nil
            self.description = nil
            self.tags = []
        }
        
        // init
        init(id: Int,
             title: String,
             authors: [String],
             position: Int = 1,
             seriesId: Int? = nil,
             publisher: String? = nil,
             publicationDate: String? = nil,
             isbn10: String? = nil,
             isbn13: String? = nil,
             pageCount: Int? = nil,
             description: String? = nil,
             tags: [String] = []) {
            self.id = id
            self.title = title
            self.authors = authors
            self.position = position
            self.seriesId = seriesId
            self.publisher = publisher
            self.publicationDate = publicationDate
            self.isbn10 = isbn10
            self.isbn13 = isbn13
            self.pageCount = pageCount
            self.description = description
            self.tags = tags
        }
        // init
        init(book: Book) {
            self.id = book.id
            self.title = book.title
            self.authors = book.authors
            self.position = book.position
            self.seriesId = book.seriesId
            self.publisher = book.publisher
            self.publicationDate = book.publicationDate
            self.isbn10 = book.isbn10
            self.isbn13 = book.isbn13
            self.pageCount = book.pageCount
            self.description = book.description
            self.tags = book.tags
        }

    }
    
    init(bookList: BookList) {
        self.books = bookList.books
    }
    
    init(books: [Book]) {
        self.books = books
    }
    
    // make booklist object from API
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
                publisher: item.publisher,
                publicationDate: item.publication_date,
                isbn10: item.isbn_10,
                isbn13: item.isbn_13,
                pageCount: item.page_count,
                description: item.description,
                tags: item.tags
            )
            
            books.append(book)
        }
    }
    
    // make temporary booklist object from Google Books API
    init(from service: GoogleBookListService) {
        books = []

        let items = service.items
        for item in items {
            let info = item.volumeInfo

            var authors: [String] = []
            for authorName in info.authors {
                authors.append(authorName)
            }

            var identifiers: [String:String] = [:]
            for industryIdentifier in info.industryIdentifiers {
                let identifierName = industryIdentifier.type
                let identifierNum = industryIdentifier.identifier
                identifiers[identifierName] = identifierNum
            }
            
            let book = BookList.Book(
                id: 0, // temporary bogus ID
                title: info.title,
                authors: authors,
                position: 1,
                seriesId: nil,
                publisher: info.publisher ?? "",
                publicationDate: info.publishedDate ?? nil,
                isbn10: identifiers["ISBN_10"] ?? nil,
                isbn13: identifiers["ISBN_13"] ?? nil,
                pageCount: info.pageCount ?? nil,
                description: info.description ?? ""
            )

            books.append(book)
        }
    }
}

// an object to match the API's JSON structure
struct BookListService: Decodable {
    let books: [Book]
    
    struct Book: Codable {
        let id: Int
        let title: String
        let authors: [String]
        let position_in_series: Int?
        let series: Int?
        let publisher: String?
        let publication_date: String?
        let isbn_10: String?
        let isbn_13: String?
        let page_count: Int?
        let description: String?
        let tags: [String]
    }
}

// an object to match the Google Books API's JSON structure
struct GoogleBookListService: Decodable {
    let totalItems: Int
    let items: [Item]
    
    struct Item: Decodable {
        let volumeInfo: VolumeInfo
        
        struct VolumeInfo: Decodable {
            let title: String
            let authors: [String]
            let publisher: String?
            let publishedDate: String?
            let description: String?
            let pageCount: Int?
            let industryIdentifiers: [IndustryIdentifier]
            
            struct IndustryIdentifier: Decodable {
                let type: String
                let identifier: String
            }
        }
    }
}
