//
//  FormBook.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class FormBook {
    var id: Int
    var title: String
    var authors: [String]
    var position: Int
    var seriesId: Int?
    var publisher: String
    var publicationDate: String
    var isbn10: String
    var isbn13: String
    var pageCount: String
    var description: String
    var tags: [String]
    
    init(book: BookList.Book) {
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.position = book.position
        self.seriesId = book.seriesId
        self.publisher = book.publisher ?? ""
        self.publicationDate = book.publicationDate ?? ""
        self.isbn10 = book.isbn10 ?? ""
        self.isbn13 = book.isbn13 ?? ""
        let pageCount: Int = book.pageCount ?? 0
        let stringified: String = (pageCount == 0 ? "" : String(pageCount))
        self.pageCount = stringified
        self.description = book.description ?? ""
        self.tags = book.tags
    }
    
    init(book: FormBook) {
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.position = book.position
        self.seriesId = book.seriesId
        self.publisher = book.publisher
        self.publicationDate = book.publicationDate
        self.isbn10 = book.isbn10
        self.isbn13 = book.isbn13
        self.pageCount = String(book.pageCount)
        self.description = book.description
        self.tags = book.tags
    }
    
    init() {
        self.id = 0
        self.title = ""
        self.authors = []
        self.position = 1
        self.seriesId = nil
        self.publisher = ""
        self.publicationDate = ""
        self.isbn10 = ""
        self.isbn13 = ""
        self.pageCount = ""
        self.description = ""
        self.tags = []
    }
}
