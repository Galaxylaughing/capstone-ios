//
//  AddBookForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBookForm: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    
    @State private var error: ErrorAlert?
    @Binding var showAddForm: Bool
    
    // form fields
    @State private var title: String = ""
    @State private var authors: [String] = []
    @State private var author: String = ""
    @State private var seriesName: String = ""
    
    // form validation
    @State private var seriesNameAccepted: Bool = false
    
    @State private var text2: String = "blank"
    
    var body: some View {
        VStack {
            Text("Add Book")
                .padding(.top)
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Title *")
                        TextField("book title", text: $title)
                    }
                }
//                AddTitleField(title: self.$title)
                
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Author *")
                        }
                        HStack {
                            TextField("author name", text: $author)
                            Spacer()
                            Button(action: { self.addAuthor() } ) {
                                Image(systemName: "plus.circle")
                            }.disabled(self.author == "")
                        }
                
//                        if authors.count > 0 {
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
//                        }
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Series")
                        HStack {
                            TextField("series name", text: $seriesName)
//                            TextField("series name", text: $seriesName, onEditingChanged: { changed in
//                                self.checkSeries(name: self.seriesName)
//                            })
                            
//                            Text(self.text2)
                            
                            if seriesNameAccepted {
                                Image(systemName: "checkmark.square.fill")
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: { self.createBook() }) {
                        HStack {
                            Spacer()
                            Text("Add Book")
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
            
        }//.navigationBarBackButtonHidden(true)
    }
    
    // SERIES FORM FIELDS
    func checkSeries(name: String) {
        self.text2 = "Editing Changed"
        print("checking series")
        // check if series name in form is one of the user's existing series
        // if yes: do nothing
        // if not: change a state value to display the other form fields a new series requires
    }
    
    // AUTHOR FORM FIELDS
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
    
    // SUBMIT FORM
    func createBook() {
        // make POST to create a book
        let response = APIHelper.postBook(token: self.currentUser.token, title: self.title, authors: self.authors)
        
        if response["success"] != nil {
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                DispatchQueue.main.async {
                    self.bookList.books.append(newBook)
                }
            }
            // should dismiss sheet if success
            self.showAddForm = false
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
        
    }
    
}

struct AddBookForm_Previews: PreviewProvider {
    @State static var showAddForm = true
    
    static var previews: some View {
        AddBookForm(showAddForm: $showAddForm)
    }
}
