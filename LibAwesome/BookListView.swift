//
//  BookListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookListView: View {
    @EnvironmentObject var env: Env
    
    @State private var error: String?
    @State private var showConfirm = false
    @State private var bookToDelete: Int = 0
    @State private var bookTitleToDelete: String = ""
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack {
                List {
                    ForEach(env.bookList.books.sorted(by: {$0 < $1})) { book in
                        NavigationLink(destination: BookDetailView().environmentObject(book)) {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                Text(book.authorNames())
                                    .font(.caption)
                            }
                        }
                    }.onDelete(perform: self.displayConfirm)
                }
                    // from https://www.hackingwithswift.com/quick-start/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically
                    .alert(isPresented: self.$showConfirm) {
                        if self.error == nil {
                            return Alert(title: Text("Delete '\(self.bookTitleToDelete)'"),
                                         message: Text("Are you sure?"),
                                         primaryButton: .destructive(Text("Delete")) {
                                            self.swipeDeleteBook()
                                },
                                         secondaryButton: .cancel()
                            )
                        } else {
                            return Alert(title: Text("Error"),
                                         message: Text(error!),
                                         dismissButton: Alert.Button.default(
                                            Text("OK"), action: {
                                                self.error = nil
                                                self.showConfirm = false
                                         }
                                )
                            )
                        }
                }
            }
            AddButton()
                .padding(10)
        }
        .navigationBarTitle("Library", displayMode: .large)
    }
    
//    func displayConfirm(at id: Int) {
//        for book in env.bookList.books {
//            if book.id == id {
//                self.bookTitleToDelete = book.title
//            }
//        }
//        self.bookToDelete = id
//        self.showConfirm = true
//    }
    
    func displayConfirm(at offsets: IndexSet) {
        let book = env.bookList.books.sorted(by: {$0 < $1})[offsets.first!]
        self.bookToDelete = book.id
        self.bookTitleToDelete = book.title
        self.showConfirm = true
    }
    
    func swipeDeleteBook() {
        self.showConfirm = false
        
        // make DELETE request
        let response = APIHelper.deleteBook(token: self.env.user.token, bookId: self.bookToDelete)
        
        if response["success"] != nil {
            // update tags
            CallAPI.updateTags(env: self.env)
            
            // remove book from environment
            if let indexToDelete = self.env.bookList.books.firstIndex(where: {$0.id == self.bookToDelete}) {
                let bookList = self.env.bookList
                bookList.books.remove(at: indexToDelete)
                DispatchQueue.main.async {
                    self.env.bookList = bookList
                }
            }
        } else if response["error"] != nil {
            self.error = response["error"]!
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        } else {
            self.error = "Unknown error"
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var exampleBook1 = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    static var exampleBook2 = BookList.Book(
        id: 2,
        title: "A Great and Terrible Beauty",
        authors: [
            "Libba Bray"
    ])
    static var bookList = BookList(books: [exampleBook1, exampleBook2])
    static var env = Env(user: Env.defaultEnv.user, bookList: bookList, seriesList: Env.defaultEnv.seriesList, tagList: Env.defaultEnv.tagList, tag: Env.defaultEnv.tag
)
    
    static var previews: some View {
        BookListView()
            .environmentObject(env)
//            .environmentObject(bookList)
    }
}
