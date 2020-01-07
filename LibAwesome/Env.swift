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
    
    init(user: User, bookList: BookList, seriesList: SeriesList) {
        self.user = user
        self.bookList = bookList
        self.seriesList = seriesList
    }
    
    init(env: Env) {
        self.user = env.user
        self.bookList = env.bookList
        self.seriesList = env.seriesList
    }
    
    init() {
        self.user = User()
        self.bookList = BookList(books: [])
        self.seriesList = SeriesList(series: [])
    }
    
    static let defaultEnv = Env()
}
