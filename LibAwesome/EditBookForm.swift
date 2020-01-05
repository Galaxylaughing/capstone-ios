//
//  EditBookForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditBookForm: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    @EnvironmentObject var book: BookList.Book
    
    @State private var error: ErrorAlert?
    
    @Binding var showEditForm: Bool
//    @State var bookToEdit: BookList.Book
    
    @State private var title: String = ""
    @State private var authors: [String] = []
    @State private var author: String = ""
    
    var body: some View {
        VStack {
            Text("Edit Book")
                .padding(.top)
            
            Form {
                Section {
                    Button(action: {self.fillFields()}) {
                        Text("populate form")
                    }
                    
                    HStack {
                        Text("Title:")
                        TextField("title", text: $title)
                            .lineLimit(nil) // if swiftui bug is fixed, will allow multiline textfield
                    }
                }
                
                Section {
                    HStack {
                        Text("Author:")
                        TextField("author", text: $author)
                        Spacer()
                        Button(action: { self.addAuthor() } ) {
                            Image(systemName: "plus.circle")
                        }.disabled(self.author == "")
                    }
                }
                
                // prevent view from assigning empty space when no authors
                Section {
                    if authors.count > 0 {
    //                    Section {
                            List {
                                ForEach(authors, id: \.self) { author in
                                    HStack {
                                        Text(author)
                                        Spacer()
                                        Text("delete")
                                        Button(action: { self.deleteAuthor(name: author) } ) {
                                            Image(systemName: "minus.circle")
                                        }
                                    }
                                }.onDelete(perform: self.swipeDeleteAuthor)
                            }
    //                    }
                    }
                }
                
                Section {
                    Button(action: { self.editBook() }) {
                        HStack {
                            Spacer()
                            Text("Save Book")
                            Spacer()
                        }
                    }
                    // disable if no title or authors
                    .disabled(self.title == "" || self.authors.count == 0)
                    .alert(item: $error, content: { error in
                        AlertHelper.alert(reason: error.reason)
                    })
                }
            }
            //.onAppear { self.fillFields() }
        }
        //.onAppear { self.fillFields() }
    }
    
    func fillFields() {
        self.title = book.title
        for author in book.authors {
            self.authors.append(author.name)
        }
    }
    
    func deleteAuthor(name: String) {
        // delete with button
        if let index = self.authors.firstIndex(of: name) {
            DispatchQueue.main.async {
                self.authors.remove(at: index)
            }
        }
    }
    
    func swipeDeleteAuthor(at offsets: IndexSet) {
        // delete by swipe
        DispatchQueue.main.async {
            self.authors.remove(atOffsets: offsets)
        }
    }
    
    func addAuthor() {
        // add author to list
        self.authors.append(self.author)
        // clear author from field
        self.author = ""
    }
    
    func editBook() {
        print("editing book")
        let response = APIHelper.patchBook(token: self.currentUser.token, bookId: book.id, title: self.title, authors: self.authors)
        
        if response["success"] != nil {
            // update book in environment
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                DispatchQueue.main.async {
                    // update book in environment's BookList
                    // find book in booklist with the newBook's id
                    if let index = self.bookList.books.firstIndex(where: { $0.id == newBook.id }) {
                        // replace book at index
                        self.bookList.books[index] = newBook
                    }
                    // update book in state
                    self.book.title = newBook.title
                    self.book.authors = newBook.authors
                }
            }
            // should dismiss sheet if success
            self.showEditForm = false
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
    }
}

struct EditBookForm_Previews: PreviewProvider {
    @State static var showEditForm = true
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            BookList.Book.Author(name: "Neil Gaiman"),
            BookList.Book.Author(name: "Terry Pratchett"),
    ])
    
    static var previews: some View {
        EditBookForm(showEditForm: $showEditForm)
            .environmentObject(self.exampleBook)
    }
}
