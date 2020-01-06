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
    @State var bookToEdit: BookList.Book
    
    @State private var author: String = ""
    
    var body: some View {
        VStack {
            Text("Edit Book")
                .padding(.top)
            
            Form {
                Section {
                    HStack {
                        Text("Title:")
                        TextField("title", text: $bookToEdit.title)
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
//                Section {
                    if bookToEdit.authors.count > 0 {
                        Section {
                            List {
                                ForEach(bookToEdit.authors, id: \.self) { author in
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
                        }
                    }
//                }
                
                Section {
                    Button(action: { self.editBook() }) {
                        HStack {
                            Spacer()
                            Text("Save Book")
                            Spacer()
                        }
                    }
                    // disable if no title or authors
                    .disabled(self.bookToEdit.title == "" || self.bookToEdit.authors.count == 0)
                    .alert(item: $error, content: { error in
                        AlertHelper.alert(reason: error.reason)
                    })
                }
            }
        }
    }
    
    func deleteAuthor(name: String) {
        // delete with button
        let book = self.bookToEdit
        if let index = book.authors.firstIndex(of: name) {
            book.authors.remove(at: index)
            self.bookToEdit = BookList.Book(book: book)
        }
    }
    
    func swipeDeleteAuthor(at offsets: IndexSet) {
        // delete by swipe
        let book = self.bookToEdit
        book.authors.remove(atOffsets: offsets)
        self.bookToEdit = BookList.Book(book: book)
    }
    
    func addAuthor() {
        // add author to list
        self.bookToEdit.authors.append(self.author)
        // clear author from field
        self.author = ""
    }
    
    func editBook() {
        print("editing book")
        let response = APIHelper.putBook(token: self.currentUser.token, bookId: book.id, title: self.bookToEdit.title, authors: self.bookToEdit.authors)
        
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
    static var bookToEdit = BookList.Book(id: 1, title: "title", authors: ["author one"])
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    
    static var previews: some View {
        EditBookForm(showEditForm: $showEditForm, bookToEdit: bookToEdit)
            .environmentObject(self.exampleBook)
    }
}
