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
    
    var body: some View {
        HStack {
            if currentUser.token != nil {
                TabbedView()
                    .onAppear { self.loadData() }
            } else {
                LoginForm()
            }
        }
    }
    
    func loadData() {
        print("I'M HERE")
        self.getBooks()
    }
    
    struct Book: Codable {
        var title: String
        var authors: [String]
    }
    
    var bookList = [
        Book(title: "The Golem and the Jinni",
             authors: ["Helene Wrecker"]),
        Book(title: "Anne of Green Gables",
             authors: ["L.M. Montgomery"]),
        Book(title: "The Vanishing Stair",
             authors: ["Maureen Johnson"]),
    ]
    
    func getBooks() {
        let response = APIHelper.getBooks(token: self.currentUser.token)
        
        if let data = response["success"] {
            
            print(data)
            EncodingHelper.makeBookList(data: data)
            
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
