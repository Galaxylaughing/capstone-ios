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
    @Binding var showForm: Bool
    
    // form fields
    @State private var title: String = ""
    @State private var authors: [String] = []
    @State private var author: String = ""
    
    @State private var assignSeries: Bool = false
    @State private var seriesIndex = 0
    @State private var seriesPositionIndex = 0
    let seriesPositions: [Int] = Array(1...100)
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.createBook() }) {
            Text("Add Book")
        }
            // disable if no title or authors
            .disabled(self.title == "" || self.authors.count == 0)
            .alert(item: $error, content: { error in
                AlertHelper.alert(reason: error.reason)
            })
    }
    
    fileprivate func cancelButton() -> some View {
        return Button(action: { self.showForm = false }) {
            Text("Cancel")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Title *")
                            TextField("book title", text: $title)
                        }
                    }
                    
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
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            
                            Toggle(isOn: $assignSeries) {
                                Text("Assign to Series")
                            }
                            
                            if self.assignSeries {
                                Text("").padding(.bottom)
                                
                                // side-by-side picker frames from  https://stackoverflow.com/questions/56961550/swiftui-placing-two-pickers-side-by-side-in-hstack-does-not-resize-pickers
                                HStack {
                                    VStack {
                                        Text("Number")
                                        Picker("Position in series", selection: $seriesPositionIndex) {
                                            ForEach(0 ..< self.seriesPositions.count) {
                                                Text("\(self.seriesPositions[$0])").tag($0)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: .infinity)
                                        .clipped()
                                    }
                                    
                                    VStack {
                                        Text("Series Name: \(self.env.seriesList.series[self.seriesIndex].name)")
                                        Picker("Series name", selection: $seriesIndex) {
                                            ForEach(0 ..< self.env.seriesList.series.count) {
                                                Text("\(self.env.seriesList.series[$0].name)").tag($0)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        .clipped()
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle("Add Book", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
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
        let seriesData = BookHelper.getSeriesId(
            seriesList: self.env.seriesList,
            assignSeries: self.assignSeries,
            seriesPositions: self.seriesPositions,
            seriesPositionIndex: self.seriesPositionIndex,
            seriesIndex: self.seriesIndex)
        
        // make POST to create a book
        let response = APIHelper.postBook(
            token: self.env.user.token,
            title: self.title,
            authors: self.authors,
            position: seriesData["position"] ?? nil,
            seriesId: seriesData["seriesId"] ?? nil)
        
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
            self.showForm = false
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
        
    }
    
}

struct AddBookForm_Previews: PreviewProvider {
    @State static var showForm = true
    
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
    static var series4 = SeriesList.Series(
        id: 4,
        name: "A Song of Ice and Fire",
        plannedCount: 6,
        books: [])
    static var seriesList = SeriesList(series: [series1, series2, series3, series4])
    static var env = Env(user: Env.defaultEnv.user, bookList: Env.defaultEnv.bookList, seriesList: seriesList)
    
    static var previews: some View {
        AddBookForm(showForm: $showForm)
            .environmentObject(env)
    }
}
