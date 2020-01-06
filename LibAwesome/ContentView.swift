//
//  ContentView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/1/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    @EnvironmentObject var seriesList: SeriesList
    
    var body: some View {
        HStack {
            if currentUser.token != nil {
                TabbedView()
                    .onAppear {
                        self.getBooks()
                        self.getSeries()
                    }
            } else {
                LoginForm()
            }
        }
    }
    
    func getBooks() {
        let response = APIHelper.getSeries(token: self.currentUser.token)
        
        if let data = response["success"] {
            let apiSeriesList = EncodingHelper.makeSeriesList(data: data) ?? SeriesList(series: [])
            // update the environment variable
            DispatchQueue.main.async {
                self.seriesList.series = apiSeriesList.series
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
    
    func getSeries() {
        let response = APIHelper.getBooks(token: self.currentUser.token)
        
        if let data = response["success"] {
            let apiBookList = EncodingHelper.makeBookList(data: data) ?? BookList(books: [])
            // update the environment variable
            DispatchQueue.main.async {
                self.bookList.books = apiBookList.books
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
        .environmentObject(User())
        .environmentObject(BookList(books: []))
        .environmentObject(SeriesList(series: []))
    }
}
