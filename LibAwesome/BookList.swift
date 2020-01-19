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
        @Published var current_status: Status
        @Published var current_status_date: Date
        @Published var rating: Rating
        @Published var tags: [String]
        @Published var status_history: [BookStatusList.BookStatus]
        
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
            self.current_status = Status.wanttoread // default status
            self.current_status_date = Date() // default status date
            self.rating = Rating.unrated
            self.tags = []
            self.status_history = []
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
             current_status: Status = Status.wanttoread, // default status
             current_status_date: Date = Date(), // default status date
             rating: Rating = Rating.unrated,
             tags: [String] = [],
             status_history: [BookStatusList.BookStatus] = []) {
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
            self.current_status = current_status
            self.current_status_date = current_status_date
            self.rating = rating
            self.tags = tags
            self.status_history = status_history
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
            self.current_status = book.current_status
            self.current_status_date = book.current_status_date
            self.rating = book.rating
            self.tags = book.tags
            self.status_history = book.status_history
        }

    }
    
    init() {
        self.books = []
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
            
            let formatter = ISO8601DateFormatter()
            let isoDate = formatter.date(from: item.current_status_date) ?? Date()
            
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
                current_status: Status(rawValue: item.current_status) ?? Status.wanttoread,
                current_status_date: isoDate,
                rating: Rating(rawValue: item.rating) ?? Rating.unrated,
                tags: item.tags,
                status_history: []
            )
            
            books.append(book)
        }
    }
    
    // make temporary booklist object from Google Books API
    init(from service: GoogleBookListService) {
        books = []

        var tempId = -1
        let items = service.items
        for item in items {
            let info = item.volumeInfo
            
            var bookTitle: String = info.title ?? ""
            if info.subtitle != nil {
                bookTitle += ": "
                bookTitle += info.subtitle!
            }

            var authors: [String] = []
            if (info.authors != nil) {
                for authorName in info.authors! {
                    authors.append(authorName)
                }
            }

            var identifiers: [String:String] = [:]
            if info.industryIdentifiers != nil {
                for industryIdentifier in info.industryIdentifiers! {
                    let identifierName = industryIdentifier.type
                    let identifierNum = industryIdentifier.identifier
                    identifiers[identifierName] = identifierNum
                }
            }
            
            let book = BookList.Book(
                id: tempId, // temporary bogus ID
                title: bookTitle,
                authors: authors,
                position: 1,
                seriesId: nil,
                publisher: info.publisher ?? "",
                publicationDate: info.publishedDate ?? nil,
                isbn10: identifiers["ISBN_10"] ?? nil,
                isbn13: identifiers["ISBN_13"] ?? nil,
                pageCount: info.pageCount ?? nil,
                description: info.description ?? "",
                current_status: Status.wanttoread, // default status
                current_status_date: Date(), // default status date
                rating: Rating.unrated
            )

            tempId -= 1
            books.append(book)
        }
    }
}

// an object to match the API's JSON structure
struct BookListService: Decodable {
    let books: [Book]
    
    struct Book: Codable {
        var id: Int
        var title: String
        var authors: [String]
        var position_in_series: Int?
        var series: Int?
        var publisher: String?
        var publication_date: String?
        var isbn_10: String?
        var isbn_13: String?
        var page_count: Int?
        var description: String?
        var current_status: String
        var current_status_date: String
        var rating: Int
        var tags: [String]
        
        init() {
            self.id = 0
            self.title = ""
            self.authors = []
            self.position_in_series = nil
            self.series = nil
            self.publisher = nil
            self.publication_date = nil
            self.isbn_10 = nil
            self.isbn_13 = nil
            self.page_count = nil
            self.description = nil
            self.current_status = Status.wanttoread.rawValue
            
            let formatter = ISO8601DateFormatter()
            let isoDateString = formatter.string(from: Date())
            
            self.current_status_date = isoDateString
            self.rating = 0
            self.tags = []
        }
        
        init(
            id: Int,
            title: String,
            authors: [String],
            position_in_series: Int?,
            series: Int?,
            publisher: String?,
            publication_date: String?,
            isbn_10: String?,
            isbn_13: String?,
            page_count: Int?,
            description: String?,
            current_status: String?,
            current_status_date: String?,
            rating: Int,
            tags: [String]
        ) {
            self.id = id
            self.title = title
            self.authors = authors
            self.position_in_series = position_in_series
            self.series = series
            self.publisher = publisher
            self.publication_date = publication_date
            self.isbn_10 = isbn_10
            self.isbn_13 = isbn_13
            self.page_count = page_count
            self.description = description
            self.current_status = current_status ?? Status.wanttoread.rawValue
            
            let formatter = ISO8601DateFormatter()
            let isoDateString = formatter.string(from: Date())
            
            self.current_status_date = current_status_date ?? isoDateString
            self.rating = rating
            self.tags = tags
        }
        
        init(from book: BookList.Book) {
            self.id = book.id
            self.title = book.title
            self.authors = book.authors
            self.position_in_series = book.position
            self.series = book.seriesId
            self.publisher = book.publisher
            self.publication_date = book.publicationDate
            self.isbn_10 = book.isbn10
            self.isbn_13 = book.isbn13
            self.page_count = book.pageCount
            self.description = book.description
            self.current_status = book.current_status.rawValue
            
            let formatter = ISO8601DateFormatter()
            let isoDateString = formatter.string(from: book.current_status_date)
            
            self.current_status_date = isoDateString //CHECK
            self.rating = book.rating.rawValue
            self.tags = book.tags
        }
    }
}

// an object to match the Google Books API's JSON structure
struct GoogleBookListService: Decodable {
    let totalItems: Int
    let items: [Item]
    
    struct Item: Decodable {
        let volumeInfo: VolumeInfo
        
        struct VolumeInfo: Decodable {
            let title: String?
            let subtitle: String?
            let authors: [String]?
            let publisher: String?
            let publishedDate: String?
            let description: String?
            let pageCount: Int?
            let industryIdentifiers: [IndustryIdentifier]?
            
            struct IndustryIdentifier: Decodable {
                let type: String
                let identifier: String
            }
        }
    }
}
