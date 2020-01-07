//
//  AddBookForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBookForm: View {
    @EnvironmentObject var env: Env
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var bookList: BookList
//    @EnvironmentObject var seriesList: SeriesList
    
    @State private var error: ErrorAlert?
    @Binding var showAddForm: Bool
    
    // form fields
    @State private var title: String = ""
    @State private var authors: [String] = []
    @State private var author: String = ""
//    @State private var showCounts: Bool = false
    @State private var seriesIndex = -1
    
    var body: some View {
        NavigationView {
        VStack {
//            Text("Add Book")
//                .padding(.top)
            
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
//                        Text("Series")
                        
                        Picker("Series:", selection: $seriesIndex) {
                            Text("stand-alone").tag(-1)
                            ForEach(0 ..< self.env.seriesList.series.count) {
                                Text("\(self.env.seriesList.series[$0].name)").tag($0)
                            }
                        }
//                        .pickerStyle(WheelPickerStyle())
//                        .labelsHidden()
                    }
                }
                
                /*
                Section {
                    VStack(alignment: .leading) {
                        Text("Series")
                        
//                        if self.showCounts {
//                            Button(action: { self.showCounts = false }) {
//                                Text("count is unknown")
//                            }
                            
                            Picker("Series:", selection: $seriesIndex) {
                                ForEach(0 ..< self.seriesIndex.count) {
                                    Text("\(self.seriesIndex[$0])").tag($0)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()
//                        } else {
//                            Button(action: { self.showCounts = true }) {
//                                Text("specify count")
//                            }
//                        }
                        
                    }
                }*/
                
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
        }.navigationBarTitle("Add Book", displayMode: .inline)
        }
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
        if self.seriesIndex == -1 {
            // post without series
        }
        // make POST to create a book
        let response = APIHelper.postBook(token: self.env.user.token, title: self.title, authors: self.authors)
        
        if response["success"] != nil {
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                let bookList = self.env.bookList
                bookList.books.append(newBook)
                DispatchQueue.main.async {
                    self.env.bookList = bookList
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
    
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 10,
        books: [])
    static var series2 = SeriesList.Series(
        id: 2,
        name: "Warrior Cats",
        plannedCount: 6,
        books: [])
    static var series3 = SeriesList.Series(
        id: 3,
        name: "Dresden Files",
        plannedCount: 0,
        books: [])
    static var seriesList = SeriesList(series: [series1, series2, series3])
    static var env = Env(user: Env.defaultEnv.user, bookList: Env.defaultEnv.bookList, seriesList: seriesList)
    
    static var previews: some View {
        AddBookForm(showAddForm: $showAddForm)
            .environmentObject(env)
    }
}
