//
//  EditBookForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditBookForm: View {
    @Binding var showForm: Bool
    @EnvironmentObject var env: Env
    @EnvironmentObject var book: BookList.Book
    
    @State private var error: ErrorAlert?
    
    @State var bookToEdit: BookList.Book
    @State private var author: String = ""
    
    @State private var assignSeries: Bool = false
    @State private var seriesIndex = -1
    @State private var seriesPositionIndex = 0
    let seriesPositions: [Int] = Array(1...100)
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.editBook() }) {
            Text("Save Book")
        }
            // disable if no title or authors
            .disabled(self.bookToEdit.title == "" || self.bookToEdit.authors.count == 0)
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
                                        Text("Series Name")
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
            .navigationBarTitle("Update Book", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
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
        let seriesData = BookHelper.getSeriesId(
            seriesList: self.env.seriesList,
            assignSeries: self.assignSeries,
            seriesPositions: self.seriesPositions,
            seriesPositionIndex: self.seriesPositionIndex,
            seriesIndex: self.seriesIndex)
        
        // make PUT to update book
        let response = APIHelper.putBook(
            token: self.env.user.token,
            bookId: book.id,
            title: self.bookToEdit.title,
            authors: self.bookToEdit.authors,
            position: seriesData["position"] ?? nil,
            seriesId: seriesData["seriesId"] ?? nil)
        
        if response["success"] != nil {
            // update book in environment
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                // update book in environment's BookList
                // find book in booklist with the newBook's id
                if let index = self.env.bookList.books.firstIndex(where: { $0.id == newBook.id }) {
                    let bookList = self.env.bookList
                    let oldBook = bookList.books[index]
                    bookList.books[index] = newBook
                    
                    if oldBook.seriesId != newBook.seriesId {
                        if let oldSeriesIndex = self.env.seriesList.series.firstIndex(where: {$0.id == oldBook.seriesId}) {
                            // remove newBook id from books list
                            var tempBooks = self.env.seriesList.series[oldSeriesIndex].books
                            if let index = tempBooks.firstIndex(of: newBook.id) {
                                tempBooks.remove(at: index)
                            }
                            self.env.seriesList.series[oldSeriesIndex].books = tempBooks
                        }
                        if let newSeriesIndex = self.env.seriesList.series.firstIndex(where: {$0.id == newBook.seriesId}) {
                            // add newBook id to books list
                            self.env.seriesList.series[newSeriesIndex].books.append(newBook.id)
                        }
                    }
                    
                    let seriesList = SeriesList(seriesList: self.env.seriesList)
                    
                    DispatchQueue.main.async {
                        // replace book at index
                        self.env.bookList = bookList
                        self.env.seriesList = seriesList
                    }
                    // update book in state
                    self.book.title = newBook.title
                    self.book.authors = newBook.authors
                    self.book.position = newBook.position
                    self.book.seriesId = newBook.seriesId
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

struct EditBookForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var bookToEdit = BookList.Book(id: 1, title: "title", authors: ["author one"])
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    
    static var previews: some View {
        EditBookForm(showForm: $showForm, bookToEdit: bookToEdit)
            .environmentObject(self.exampleBook)
    }
}
