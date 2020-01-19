//
//  Env.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class Env: ObservableObject {
    @Published var topView: TopViews = .home
    @Published var user: User
    @Published var bookList: BookList
    @Published var authorList: AuthorList
    @Published var seriesList: SeriesList
    @Published var tagList: TagList
    @Published var tag: TagList.Tag
    @Published var tagToEdit: TagList.Tag
    @Published var book: BookList.Book
    @Published var currentReadsCount: Int
    @Published var selectedStatusFilter: Status?
    @Published var selectedAuthorFilter: String?
    
    init(user: User, bookList: BookList, book: BookList.Book = BookList.Book(), authorList: AuthorList, seriesList: SeriesList, tagList: TagList, tag: TagList.Tag, tagToEdit: TagList.Tag) {
        self.user = user
        self.bookList = bookList
        self.authorList = authorList
        self.seriesList = seriesList
        self.tagList = tagList
        self.tag = tag
        self.tagToEdit = tagToEdit
        self.book = book
        self.currentReadsCount = Env.getCurrentReadsCount(from: bookList) //CHECK
    }
    
    init(env: Env) {
        self.user = env.user
        self.bookList = env.bookList
        self.authorList = env.authorList
        self.seriesList = env.seriesList
        self.tagList = env.tagList
        self.tag = env.tag
        self.tagToEdit = env.tagToEdit
        self.book = BookList.Book()
        self.currentReadsCount = env.currentReadsCount //CHECK
    }
    
    init() {
        self.user = User()
        self.bookList = BookList(books: [])
        self.authorList = AuthorList()
        self.seriesList = SeriesList(series: [])
        self.tagList = TagList(tags: [])
        self.tag = TagList.Tag(name: "", books: [])
        self.tagToEdit = TagList.Tag(name: "", books: [])
        self.book = BookList.Book()
        self.currentReadsCount = 0 //CHECK
    }
    
    static let defaultEnv = Env()
    
    // functions
    static func setEnv(in env: Env, to newBookList: BookList) {
        // update authors
        let updatedAuthorList = EncodingHelper.getAuthors(from: newBookList)
        
        // update tags
        let updatedTagList = EncodingHelper.getTags(from: newBookList)
        
        // set environment
        DispatchQueue.main.async {
            env.bookList = newBookList
            env.authorList = updatedAuthorList
            env.tagList = updatedTagList
        }
    }
    
    static func getCurrentReadsCount(from bookList: BookList) -> Int {
        var currentReadsCount = 0
        
        for book in bookList.books {
            if book.current_status == Status.current {
                currentReadsCount += 1
            }
        }
        
        return currentReadsCount
    }
    
    static func getCurrentReads(from bookList: BookList) -> BookList {
        let currentReads: BookList = BookList()
        
        for book in bookList.books {
            if book.current_status == Status.current {
                currentReads.books.append(book)
            }
        }
        
        return currentReads
    }
}
