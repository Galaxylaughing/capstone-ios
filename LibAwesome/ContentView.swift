//
//  ContentView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/1/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        HStack {
            if self.env.user.token != nil {
                TabbedView()
                    .onAppear {
                        self.getBooks()
                        self.getSeries()
                        self.getTags()
                    }
            } else {
                LoginForm()
            }
        }
    }
    
    func getTags() {
        print("I'm going to go get the tags")
        
        let response = APIHelper.getTags(token: self.env.user.token)
        
        if let data = response["success"] {
            // {"tags":[{"name":"non-fiction","books":[40,44]},{"name":"non-fiction/historical","books":[40]},{"name":"fiction","books":[44]}]}
            let apiTagList = EncodingHelper.makeTagList(data: data) ?? TagList(tags: [])
            // update the environment variable
            DispatchQueue.main.async {
                self.env.tagList = apiTagList
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
    
    func getSeries() {
        let response = APIHelper.getSeries(token: self.env.user.token)
        
        if let data = response["success"] {
            let apiSeriesList = EncodingHelper.makeSeriesList(data: data) ?? SeriesList(series: [])
            // update the environment variable
            DispatchQueue.main.async {
                self.env.seriesList = apiSeriesList
//                self.seriesList.series = apiSeriesList.series
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
    
    func getBooks() {
        let response = APIHelper.getBooks(token: self.env.user.token)
        
        if let data = response["success"] {
            let apiBookList = EncodingHelper.makeBookList(data: data) ?? BookList(books: [])
            // update the environment variable
            DispatchQueue.main.async {
                self.env.bookList = apiBookList
//                self.bookList.books = apiBookList.books
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
        .environmentObject(Env.defaultEnv)
//        .environmentObject(User())
//        .environmentObject(BookList(books: []))
//        .environmentObject(SeriesList(series: []))
    }
}
