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
    @State private var bookToAdd: FormBook = FormBook()
    
    @State private var error: ErrorAlert?
    @Binding var showForm: Bool
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.createBook() }) {
            Text("Add Book")
        }
            // disable if no title or authors
            .disabled(self.bookToAdd.title == "" || self.bookToAdd.authors.count == 0)
            .alert(item: $error, content: { error in
                AlertHelper.alert(reason: error.reason)
            })
    }
    
    fileprivate func cancelButton() -> some View {
        return Button(action: { self.showForm = false }) {
            Text("Cancel")
        }
    }
    
    // TITLE SECTION
    func addBookTitle() -> some View {
        return Section(header: Text("title")) {
            VStack(alignment: .leading) {
                TextField("book title", text: $bookToAdd.title)
            }
        }
    }
    
    // AUTHOR SECTION
    @State private var author: String = ""
    func deleteAuthor(name: String) {
        // delete with button
        if let index = self.bookToAdd.authors.firstIndex(of: name) {
            DispatchQueue.main.async {
                self.bookToAdd.authors.remove(at: index)
            }
        }
    }
    func swipeDeleteAuthor(at offsets: IndexSet) {
        // delete by swipe
        DispatchQueue.main.async {
            self.bookToAdd.authors.remove(atOffsets: offsets)
        }
    }
    func addAuthor() {
        // add author to list
        self.bookToAdd.authors.append(self.author)
        // clear author from field
        self.author = ""
    }
    func addBookAuthors() -> some View {
        return Section(header: Text("author(s)")) {
            VStack(alignment: .leading) {
                HStack {
                    TextField("author name", text: $author)
                    Spacer()
                    Button(action: { self.addAuthor() } ) {
                        Image(systemName: "plus.circle")
                    }.disabled(self.author == "")
                }
            }
            List {
                ForEach(bookToAdd.authors, id: \.self) { author in
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
    
    
    // SERIES SECTION
    @State private var assignSeries: Bool = false
    @State private var seriesIndex = 0
    @State private var seriesPositionIndex = 0
    let seriesPositions: [Int] = Array(1...100)
    
    func addBookSeries() -> some View {
        return Section(header: Text("add to series")) {
            VStack(alignment: .leading) {
                Toggle(isOn: $assignSeries) {
                    Text("Assign to Series")
                }
                .disabled(!(self.env.seriesList.series.count > 0))
                
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
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                }
                
            }
        }
    }
    
    // TAG SECTION
    @State var tagChecklist: [CheckListItem] = []
    @State private var newTag: String = ""
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
            let checklistitem = CheckListItem(isChecked: false, content: tag.name)
            checklist.append(checklistitem)
        }
        // sort checklist alphabetically
        let alphaChecklist = checklist.sorted(by: {$0 < $1})
        self.tagChecklist = alphaChecklist
    }
    func unBuildTagChecklist() {
        // assign correct tags to self.tags based on checklist
        for item in self.tagChecklist {
            if item.isChecked {
                self.bookToAdd.tags.append(item.content)
            }
        }
    }
    func addBookTags() -> some View {
        return TagUpdate(
            tagChecklist: self.$tagChecklist,
            newTag: self.$newTag,
            addTag: { self.addTag() }
        )
    }
    
    // ISBN SECTION
    func editBookIsbn() -> some View {
        return Section(header: Text("ISBN")) {
            VStack {
                HStack {
                    Text("ISBN-10")
                    Divider()
                    TextField("ISBN-10", text: $bookToAdd.isbn10)
                }
                HStack {
                    Text("ISBN-13")
                    Divider()
                    TextField("ISBN-13", text: $bookToAdd.isbn13)
                }
            }
        }
    }
    
    // PAGE COUNT SECTION
    func editBookPageCount() -> some View {
        return HStack {
                Text("Page Count")
                Divider()
                TextField("page count", text: $bookToAdd.pageCount)
            }
    }
    
    // PUBLICATION INFO SECTION
    func editBookPub() -> some View {
        return Section(header: Text("publication information")) {
            VStack {
                self.editBookPageCount()
                HStack {
                    Text("Publisher")
                    Divider()
                    TextField("publisher", text: $bookToAdd.publisher)
                }
                HStack {
                    Text("Publication Date")
                    Divider()
                    TextField("YYYY-MM-DD", text: $bookToAdd.publicationDate)
                }
            }
        }
    }
    
    // DESCRIPTION SECTION
    func editBookDescription() -> some View {
        return Section(header: Text("description")) {
            VStack {
                TextField("description", text: $bookToAdd.description)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    self.addBookTitle()
                    self.addBookAuthors()
                    
                    self.addBookSeries()
                    self.addBookTags()
                    
                    self.editBookIsbn()
                    self.editBookPub()
                    self.editBookDescription()
                }
            }
            .navigationBarTitle("Add Book", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
        .onAppear(perform: {self.buildTagChecklist()})
    }
    
    fileprivate func prepBookToSend(book: FormBook) -> BookListService.Book {
        var bookToSend: BookListService.Book = BookListService.Book()

        // determine title
        bookToSend.title = self.bookToAdd.title
        // determine authors
        bookToSend.authors = self.bookToAdd.authors

        // determine tags
        self.unBuildTagChecklist()
        let uncleanTags = self.bookToAdd.tags
        var cleanTags: [String] = []
        for tag in uncleanTags {
            let cleanTagName = /*EncodingHelper.cleanTagNamesForDatabase(tagName:*/ tag/*)*/
            cleanTags.append(cleanTagName)
        }
        bookToSend.tags = cleanTags
        Debug.debug(msg: "    tags: \(bookToSend.tags)", level: .verbose)

        // determine series information
        let seriesData = BookHelper.getSeriesId(
            seriesList: self.env.seriesList,
            assignSeries: self.assignSeries,
            seriesPositions: self.seriesPositions,
            seriesPositionIndex: self.seriesPositionIndex,
            seriesIndex: self.seriesIndex)
        let position = seriesData["position"] ?? nil
        let seriesId = seriesData["seriesId"] ?? nil
        bookToSend.position_in_series = position
        bookToSend.series = seriesId
        Debug.debug(msg: "    position \(String(describing: bookToSend.position_in_series)) in series \(String(describing: bookToSend.series))", level: .verbose)
        
        // determine ISBNs
        if self.bookToAdd.isbn10 == "" {
            bookToSend.isbn_10 = nil
        } else {
            bookToSend.isbn_10 = self.bookToAdd.isbn10
        }
        if self.bookToAdd.isbn13 == "" {
            bookToSend.isbn_13 = nil
        } else {
            bookToSend.isbn_13 = self.bookToAdd.isbn13
        }
        Debug.debug(msg: "    ISBN-10: \(bookToSend.isbn_10 ?? "none")", level: .verbose)
        Debug.debug(msg: "    ISBN-10: \(bookToSend.isbn_13 ?? "none")", level: .verbose)

        // determine publication info
        if self.bookToAdd.publisher == "" {
            bookToSend.publisher = nil
        } else {
            bookToSend.publisher = self.bookToAdd.publisher
        }
        if self.bookToAdd.publicationDate == "" {
            bookToSend.publication_date = nil
        } else {
            bookToSend.publication_date = self.bookToAdd.publicationDate
        }
        Debug.debug(msg: "    Publisher: \(bookToSend.publisher ?? "none")", level: .verbose)
        Debug.debug(msg: "    PublicationDate: \(bookToSend.publication_date ?? "none")", level: .verbose)

        // determine page count
        let stringPageCount = self.bookToAdd.pageCount
        let cleanPageCount = stringPageCount.components(
            separatedBy: CharacterSet.decimalDigits.inverted).joined()
        // Int() produces nil for not-numberifiable strings, including empty string
        let numberified = Int(cleanPageCount)
        bookToSend.page_count = numberified
        Debug.debug(msg: "    page count: \(String(describing: bookToSend.page_count))", level: .verbose)

        // determine description
        if self.bookToAdd.description == "" {
            bookToSend.description = nil
        } else {
            bookToSend.description = self.bookToAdd.description
        }
        Debug.debug(msg: "    Description: \(bookToSend.description ?? "none")", level: .verbose)
        
        return bookToSend
    }
    
    // SUBMIT FORM
    func createBook() {
        // make POST to create a book
        let bookToSend = self.prepBookToSend(book: self.bookToAdd)
        let response = APIHelper.postBook(
            token: self.env.user.token,
            book: bookToSend)
    
        if response["success"] != nil {
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                let bookList = self.env.bookList
                bookList.books.append(newBook)
                // set series if there is one
                if newBook.seriesId != nil {
                    if let index = self.env.seriesList.series.firstIndex(where: {$0.id == newBook.seriesId}) {
                        // add newBook id to books list
                        self.env.seriesList.series[index].books.append(newBook.id)
                    }
                }
                let seriesList = SeriesList(seriesList: self.env.seriesList)
                DispatchQueue.main.async {
                    self.env.seriesList = seriesList
                    self.env.book = newBook
                    self.env.topView = .bookdetail
                }
                
                Env.setEnv(in: self.env, to: bookList)
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
        authorList: Env.defaultEnv.authorList,
        seriesList: seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        AddBookForm(showForm: $showForm)
            .environmentObject(env)
    }
}
