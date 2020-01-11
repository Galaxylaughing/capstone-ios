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
    
    init(user: User, bookList: BookList, authorList: AuthorList, seriesList: SeriesList, tagList: TagList, tag: TagList.Tag) {
        self.user = user
        self.bookList = bookList
        self.authorList = authorList
        self.seriesList = seriesList
        self.tagList = tagList
        self.tag = tag
    }
    
    init(env: Env) {
        self.user = env.user
        self.bookList = env.bookList
        self.authorList = env.authorList
        self.seriesList = env.seriesList
        self.tagList = env.tagList
        self.tag = env.tag
    }
    
    init() {
        self.user = User()
        self.bookList = BookList(books: [])
        self.authorList = AuthorList()
        self.seriesList = SeriesList(series: [])
        self.tagList = TagList(tags: [])
        self.tag = TagList.Tag(name: "", books: [])
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
}
