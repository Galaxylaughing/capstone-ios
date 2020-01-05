//
//  LibraryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    
    @State private var error: String?
    @State private var showConfirm = false
    @State private var bookToDelete: Int = 0
    @State private var bookTitleToDelete: String = ""
    
    var body: some View {
        NavigationView{
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                VStack {
                    List {
                        ForEach(bookList.books.sorted(by: {$0 < $1})) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
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
                    .padding([.bottom, .trailing])
            }
            .navigationBarTitle("Library", displayMode: .large)
            .navigationBarItems(trailing: LogoutButton())
        }
    }
    
    func displayConfirm(at offsets: IndexSet) {
        let book = bookList.books.sorted(by: {$0 < $1})[offsets.first!]
        self.bookToDelete = book.id
        self.bookTitleToDelete = book.title
        self.showConfirm = true
    }
    
    func swipeDeleteBook() {
        self.showConfirm = false
        
        // make DELETE request
        let response = APIHelper.deleteBook(token: self.currentUser.token, bookId: self.bookToDelete)
        
        if response["success"] != nil {
            // remove book from environment
            if let indexToDelete = self.bookList.books.firstIndex(where: {$0.id == self.bookToDelete}) {
                DispatchQueue.main.async {
                    self.bookList.books.remove(at: indexToDelete)
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
    
//    func createBook() {
//        // make POST to create a book
//        let response = APIHelper.postBook(token: self.currentUser.token, title: self.title, authors: self.authors)
//
//        if response["success"] != nil {
//            // add new book to environment BookList
//            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
//                DispatchQueue.main.async {
//                    self.bookList.books.append(newBook)
//                }
//            }
//            // should dismiss sheet if success
//            self.showAddForm = false
//        } else if response["error"] != nil {
//            // should pop up error if failure
//            self.error = ErrorAlert(reason: response["error"]!)
//        } else {
//            self.error = ErrorAlert(reason: "Unknown error")
//        }
//
//    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var exampleBook1 = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            BookList.Book.Author(name: "Neil Gaiman"),
            BookList.Book.Author(name: "Terry Pratchett"),
    ])
    static var exampleBook2 = BookList.Book(
        id: 2,
        title: "A Great and Terrible Beauty",
        authors: [
            BookList.Book.Author(name: "Libba Bray")
    ])
    static var bookList = BookList(books: [exampleBook1, exampleBook2])
    
    static var previews: some View {
        LibraryView()
            .environmentObject(bookList)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}
