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
    
    @State var assignSeries: Bool
    @State var seriesIndex: Int
    @State var seriesPositionIndex: Int
    let seriesPositions: [Int] = Array(1...100)
    
    @State var tagChecklist: [CheckListItem] = []
    @State private var newTag: String = ""
    
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
                    Section(header: Text("title")) {
                        HStack {
//                            Text("Title:")
                            TextField("title", text: $bookToEdit.title)
                                .lineLimit(nil) // if swiftui bug is fixed, will allow multiline textfield
                        }
                    }
                    
                    Section(header: Text("author(s)")) {
                        // prevent view from assigning empty space when no authors
                        if bookToEdit.authors.count > 0 {
                            List {
                                ForEach(bookToEdit.authors, id: \.self) { author in
                                    HStack {
                                        Text(author)
                                        Spacer()
                                        Button(action: { self.deleteAuthor(name: author) } ) {
                                            Image(systemName: "minus.circle")
                                        }
                                    }
                                }.onDelete(perform: self.swipeDeleteAuthor)
                            }
                        }
                        
                        HStack {
//                            Text("Author:")
                            TextField("add another author", text: $author)
                            Spacer()
                            Button(action: { self.addAuthor() } ) {
                                Image(systemName: "plus.circle")
                            }.disabled(self.author == "")
                        }
                    }
                    
                    Section(header: Text("add to series")) {
                        VStack(alignment: .leading) {
                            
                            Toggle(isOn: $assignSeries) {
                                Text("Assign to Series")
                            }
                            
                            if self.assignSeries {
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
                                        .frame(minWidth: 0, maxWidth: 100, minHeight: 0)
                                        .clipped()
                                    }
                                    
                                    VStack {
                                        Text("Series Name")
                                        Picker("Series name", selection: $seriesIndex) {
                                            ForEach(0 ..< self.env.seriesList.series.count) {
                                                Text("\(self.env.seriesList.series[$0].name)").tag($0+1)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                                        .clipped()
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                            }
                            
                        }
                    }
                    
                    Section(header: Text("add tags")) { // tags
                        HStack {
                            TextField("add tag", text: $newTag)
                                .autocapitalization(.none)
                            Spacer()
                            Button(action: { self.addTag() } ) {
                                Image(systemName: "plus.circle")
                            }.disabled(self.newTag == "")
                        }
                        
                        VStack(alignment: .leading) {
                            CheckList(list: self.$tagChecklist)
                        }
                    }
                }
            }
            .navigationBarTitle("Update Book", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
        .onAppear(perform: {self.buildTagChecklist()})
    }
    
    func addTag() {
        // add tag to checklist
        var checklist: [CheckListItem] = self.tagChecklist
        let newChecklistItem = CheckListItem(isChecked: true, content: self.newTag)
        checklist.append(newChecklistItem)
        // sort checklist alphabetically
        let alphaChecklist = checklist.sorted(by: {$0 < $1})
        self.tagChecklist = alphaChecklist
        // clear tag from field
        self.newTag = ""
    }

    func buildTagChecklist() {
        var checklist: [CheckListItem] = []
        // convert env tags to checklist items
        for tag in self.env.tagList.tags {
            // determine if they should be checked or not by comparing with bookToEdit's tags
            var isChecked: Bool = false
            if self.bookToEdit.tags.contains(tag.name) {
                isChecked = true
            }
            let checklistitem = CheckListItem(isChecked: isChecked, content: tag.name)
            checklist.append(checklistitem)
        }
        // sort checklist alphabetically
        let alphaChecklist = checklist.sorted(by: {$0 < $1})
        self.tagChecklist = alphaChecklist
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
    
    func onChecklistSubmit() {
        for item in self.tagChecklist {
            print(item.content, item.isChecked)
        }
    }
    
    func unBuildTagChecklist() {
        // assign correct tags to self.bookToEdit based on checklist
        for item in self.tagChecklist {
            if item.isChecked {
                self.bookToEdit.tags.append(item.content)
            } else {
                // remove any unchecked tags from bookToEdit
                if let index = self.bookToEdit.tags.firstIndex(of: item.content) {
                    self.bookToEdit.tags.remove(at: index)
                }
            }
        }
    }
    
    func updateTags() {
        CallAPI.getTags(env: self.env)
    }
    
    func editBook() {
        self.onChecklistSubmit() // should print current checklist values
        self.unBuildTagChecklist()
        print("BOOK'S TAGS:", self.bookToEdit.tags)
        
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
            seriesId: seriesData["seriesId"] ?? nil,
            tags: self.bookToEdit.tags)
        
        // update environment's taglist
        self.updateTags()
        
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
                        // also need to update tagList
                    }
                    // update book in state
                    self.book.title = newBook.title
                    self.book.authors = newBook.authors
                    self.book.position = newBook.position
                    self.book.seriesId = newBook.seriesId
                    self.book.tags = newBook.tags
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
    
    static var tag0 = TagList.Tag(
        name: "non-fiction",
        books: [])
    static var tag1 = TagList.Tag(
        name: "fantasy",
        books: [])
    static var tag2 = TagList.Tag(
        name: "science-fiction",
        books: [])
    static var tag3 = TagList.Tag(
        name: "mystery",
        books: [])
    static var tag4 = TagList.Tag(
        name: "fantasy/contemporary",
        books: [])
    static var tagList = TagList(tags: [tag0, tag1, tag2, tag3, tag4])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: Env.defaultEnv.bookList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag)
    
    static var previews: some View {
        EditBookForm(showForm: $showForm, bookToEdit: bookToEdit, assignSeries: false, seriesIndex: 1, seriesPositionIndex: 1)
            .environmentObject(self.exampleBook)
            .environmentObject(self.env)
    }
}
