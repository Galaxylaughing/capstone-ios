//
//  Env.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class Env: ObservableObject {
    @Published var user: User
    @Published var bookList: BookList
    @Published var seriesList: SeriesList
    @Published var tagList: TagList
    @Published var tag: TagList.Tag
    
    init(user: User, bookList: BookList, seriesList: SeriesList, tagList: TagList, tag: TagList.Tag) {
        self.user = user
        self.bookList = bookList
        self.seriesList = seriesList
        self.tagList = tagList
        self.tag = tag
    }
    
    init(env: Env) {
        self.user = env.user
        self.bookList = env.bookList
        self.seriesList = env.seriesList
        self.tagList = env.tagList
        self.tag = env.tag
    }
    
    init() {
        self.user = User()
        self.bookList = BookList(books: [])
        self.seriesList = SeriesList(series: [])
        self.tagList = TagList(tags: [])
        self.tag = TagList.Tag(name: "", books: [])
    }
    
    static let defaultEnv = Env()
}
