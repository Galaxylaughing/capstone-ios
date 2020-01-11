//
//  AuthorList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/10/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class AuthorList: ObservableObject {
    @Published var authors: [Author]
    
    init() {
        self.authors = []
    }
    
    init(authorList: AuthorList) {
        self.authors = authorList.authors
    }
    
    init(authors: [Author]) {
        self.authors = authors
    }
    
    init(from source: BookList) {
        var tempAuthors: [AuthorList.Author] = []
        var authorNames: [String] = []
        // go through each book in booklist
        for book in source.books {
            // go through each of that book's authors
            for author in book.authors {
                // is that author in the name list?
                if authorNames.contains(author) {
                    // find this author in the temp list add this book to their list of books
                    if let index = tempAuthors.firstIndex(where: {$0.name == author}) {
                        tempAuthors[index].books.append(book)
                    }
                } else {
                    // add this author to the list of names
                    authorNames.append(author)
                    // add the author to the temp list and add this book to their list of books
                    let newAuthor = AuthorList.Author(name: author, books: [book])
                    tempAuthors.append(newAuthor)
                }
            }
        }
        self.authors = tempAuthors
    }
    
    class Author: Comparable, Identifiable, ObservableObject {
        @Published var name: String
        @Published var books: [BookList.Book]
        
        init() {
            self.name = ""
            self.books = []
        }
        
        init(author: Author) {
            self.name = author.name
            self.books = author.books
        }
        
        init(name: String, books: [BookList.Book]) {
            self.name = name
            self.books = books
        }
        
        // conform to Comparable
        static func < (lhs: Author, rhs: Author) -> Bool {
            return lhs.name < rhs.name
        }
        static func == (lhs: Author, rhs: Author) -> Bool {
            return lhs.name == rhs.name
        }
    }
}
