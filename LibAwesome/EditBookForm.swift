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
    @State var bookToEdit: FormBook

    @State private var error: ErrorAlert?
    
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
       
    // TITLE SECTION
    func editBookTitle() -> some View {
        return Section(header: Text("title")) {
           HStack {
               TextField("title", text: $bookToEdit.title)
                   .lineLimit(nil) // if swiftui bug is fixed, will allow multiline textfield
           }
       }
    }

    // AUTHOR SECTION
    @State private var author: String = ""
    
    func deleteAuthor(name: String) {
        // delete with button
        let book = self.bookToEdit
        if let index = book.authors.firstIndex(of: name) {
            book.authors.remove(at: index)
            self.bookToEdit = FormBook(book: book)
        }
    }
    func swipeDeleteAuthor(at offsets: IndexSet) {
        // delete by swipe
        let book = self.bookToEdit
        book.authors.remove(atOffsets: offsets)
        self.bookToEdit = FormBook(book: book)
    }
    
    func addAuthor() {
        // add author to list
        self.bookToEdit.authors.append(self.author)
        // clear author from field
        self.author = ""
    }
    
    func editBookAuthors() -> some View {
        return Section(header: Text("author(s)")) {
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
                TextField("add another author", text: $author)
                Spacer()
                Button(action: { self.addAuthor() } ) {
                    Image(systemName: "plus.circle")
                }.disabled(self.author == "")
            }
        }
    }
    
    // SERIES SECTION
    @State var assignSeries: Bool
    @State var seriesIndex: Int
    @State var seriesPositionIndex: Int
    let seriesPositions: [Int] = Array(1...100)
    
    func editBookSeries() -> some View {
        return Section(header: Text("add to series")) {
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
    
    func editBookTags() -> some View {
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
                    TextField("ISBN-10", text: $bookToEdit.isbn10)
                }
                HStack {
                    Text("ISBN-13")
                    Divider()
                    TextField("ISBN-13", text: $bookToEdit.isbn13)
                }
            }
        }
    }
    
    // PAGE COUNT SECTION
    func editBookPageCount() -> some View {
        return HStack {
                Text("Page Count")
                Divider()
                TextField("page count", text: $bookToEdit.pageCount)
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
                    TextField("publisher", text: $bookToEdit.publisher)
                }
                HStack {
                    Text("Publication Date")
                    Divider()
                    TextField("YYYY-MM-DD", text: $bookToEdit.publicationDate)
                }
            }
        }
    }
    
    // DESCRIPTION SECTION
    func editBookDescription() -> some View {
        return Section(header: Text("description")) {
            VStack {
                TextField("description", text: $bookToEdit.description)
            }
        }
    }
    
    // EDIT BOOK FORM BODY
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    self.editBookTitle()
                    self.editBookAuthors()
                    
                    self.editBookSeries()
                    self.editBookTags()
                    
                    self.editBookIsbn()
                    self.editBookPub()
                    self.editBookDescription()
                }
            }
            .navigationBarTitle("Update Book", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
        .onAppear(perform: {self.buildTagChecklist()})
    }
    
    fileprivate func prepBookToSend(book: FormBook) -> BookListService.Book {
        let prepBook: BookList.Book = BookList.Book()
        
        // determine title
        prepBook.title = self.bookToEdit.title
        // determine authors
        prepBook.authors = self.bookToEdit.authors
        
        // determine tags
        self.unBuildTagChecklist()
        prepBook.tags = self.bookToEdit.tags
        Debug.debug(msg: "    tags: \(prepBook.tags)", level: .debug)
        
        // determine series information
        let seriesData = BookHelper.getSeriesId(
            seriesList: self.env.seriesList,
            assignSeries: self.assignSeries,
            seriesPositions: self.seriesPositions,
            seriesPositionIndex: self.seriesPositionIndex,
            seriesIndex: self.seriesIndex)
        let position = seriesData["position"] ?? nil
        let seriesId = seriesData["seriesId"] ?? nil
        prepBook.position = position ?? -1
        prepBook.seriesId = seriesId ?? -1
        Debug.debug(msg: "    position \(prepBook.position) in series \(String(describing: prepBook.seriesId))", level: .debug)
        
        // determine ISBNs
        if self.bookToEdit.isbn10 == "" {
            prepBook.isbn10 = nil
        } else {
            prepBook.isbn10 = self.bookToEdit.isbn10
        }
        if self.bookToEdit.isbn13 == "" {
            prepBook.isbn13 = nil
        } else {
            prepBook.isbn13 = self.bookToEdit.isbn13
        }
        Debug.debug(msg: "    ISBN-10: \(prepBook.isbn10 ?? "none")", level: .debug)
        Debug.debug(msg: "    ISBN-10: \(prepBook.isbn13 ?? "none")", level: .debug)
        
        // determine publication info
        if self.bookToEdit.publisher == "" {
            prepBook.publisher = nil
        } else {
            prepBook.publisher = self.bookToEdit.publisher
        }
        if self.bookToEdit.publicationDate == "" {
            prepBook.publicationDate = nil
        } else {
            prepBook.publicationDate = self.bookToEdit.publicationDate
        }
        Debug.debug(msg: "    Publisher: \(prepBook.publisher ?? "none")", level: .debug)
        Debug.debug(msg: "    PublicationDate: \(prepBook.publicationDate ?? "none")", level: .debug)
        
        // determine page count
        let stringPageCount = self.bookToEdit.pageCount
        let cleanPageCount = stringPageCount.replacingOccurrences(of: ",", with: "")
        // Int(x) produces nil for not-numberifiable strings, including empty string
        let numberified = Int(cleanPageCount)
        if numberified == nil {
            prepBook.pageCount = -1
        } else {
            prepBook.pageCount = numberified!
        }
        Debug.debug(msg: "    page count: \(String(describing: prepBook.pageCount))", level: .debug)
        
        // determine description
        if self.bookToEdit.description == "" {
            prepBook.description = nil
        } else {
            prepBook.description = self.bookToEdit.description
        }
        Debug.debug(msg: "    Description: \(prepBook.description ?? "none")", level: .debug)
        
        let bookToSend = BookListService.Book(from: prepBook)
        return bookToSend
    }
    
    func editBook() {
        // make PUT to update book
        let bookToSend = self.prepBookToSend(book: self.bookToEdit)
        let response = APIHelper.putBook(
            token: self.env.user.token,
            bookId: self.env.book.id,
            book: bookToSend)
        
        if response["success"] != nil {
            Debug.debug(msg: "Successfully returned from API call", level: .debug)
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                Debug.debug(msg: "Successfully encoded new book", level: .debug)
                
                // update book in environment's BookList
                if let index = self.env.bookList.books.firstIndex(where: { $0.id == newBook.id }) {
                    let bookList = self.env.bookList
                    let oldBook = bookList.books[index]
                    bookList.books[index] = newBook
                    
                    // update the seriesList in the environment
                    if oldBook.seriesId != newBook.seriesId {
                        if let oldSeriesIndex = self.env.seriesList.series.firstIndex(where: { $0.id == oldBook.seriesId }) {
                            // remove newBook id from books list
                            var tempBooks = self.env.seriesList.series[oldSeriesIndex].books
                            if let index = tempBooks.firstIndex(of: newBook.id) {
                                tempBooks.remove(at: index)
                            }
                            self.env.seriesList.series[oldSeriesIndex].books = tempBooks
                        }
                        if let newSeriesIndex = self.env.seriesList.series.firstIndex(where: { $0.id == newBook.seriesId }) {
                            // add newBook id to books list
                            self.env.seriesList.series[newSeriesIndex].books.append(newBook.id)
                        }
                    }
                    let seriesList = SeriesList(seriesList: self.env.seriesList)
                    
                    Env.setEnv(in: self.env, to: bookList)
                    
                    let currentTag = self.env.tag
                    for book in currentTag.books {
                        if book.id == newBook.id && !newBook.tags.contains(currentTag.name) {
                            // remove book from currentTag
                            if let index = currentTag.books.firstIndex(where: { $0.id == book.id }) {
                                currentTag.books.remove(at: index)
                            }
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.env.book = newBook
                        self.env.topView = .bookdetail
                        self.env.seriesList = seriesList
                        self.env.tag = TagList.Tag(name: currentTag.name, books: currentTag.books)
                    }
                }
            }
            // dismiss sheet if success
            self.showForm = false
        } else if response["error"] != nil {
            // pop up error if failure
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
        authorList: Env.defaultEnv.authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        EditBookForm(
            showForm: $showForm,
            bookToEdit: FormBook(book: bookToEdit),
            assignSeries: false,
            seriesIndex: 1,
            seriesPositionIndex: 1
        )
            .environmentObject(self.env)
    }
}
