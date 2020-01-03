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
    
    var body: some View {
        HStack {
            if currentUser.token != nil {
                TabbedView()
                    .onAppear { self.getBooks() }
            } else {
                LoginForm()
            }
        }
    }
    
    func getBooks() {
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
       ContentView().environmentObject(User())
          .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
          .previewDisplayName("iPhone 8")
    }
}
