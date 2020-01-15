//
//  AddBySearchForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBySearchForm: View {
    @EnvironmentObject var env: Env
    static var searchResults: BookList = BookList()
    
    @State private var error: ErrorAlert?
    @Binding var showForm: Bool
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.addBook() }) {
            Text("Add Book")
        }
        .disabled(self.title == "" && self.authors == [])
        .alert(item: $error, content: { error in
            AlertHelper.alert(reason: error.reason)
        })
    }

    fileprivate func cancelButton() -> some View {
        return Button(action: { self.showForm = false }) {
            Text("Cancel")
        }
    }
    
    // TITLE
    @State private var title: String = ""
    func searchTitle() -> some View {
        return Section(header: Text("Title")) {
            VStack(alignment: .leading) {
                TextField("title", text: $title)
            }
        }
    }
    
    // AUTHORS
    @State private var authors: [String] = []
    @State private var author: String = ""
    func removeAuthorName(name: String) {
        // delete with button
        if let index = self.authors.firstIndex(of: name) {
            self.authors.remove(at: index)
        }
    }
    func swipeRemoveAuthorName(at offsets: IndexSet) {
        // delete by swipe
        self.authors.remove(atOffsets: offsets)
    }
    func addAuthorName(name: String) {
        // add author to list
        self.authors.append(name)
        // clear author from field
        self.author = ""
    }
    func searchAuthors() -> some View {
        return Section(header: Text("Authors")) {
            if self.authors.count > 0 {
                List {
                    ForEach(self.authors, id: \.self) { author in
                        HStack {
                            Text(author)
                            Spacer()
                            Button(action: { self.removeAuthorName(name: author) }) {
                                Image(systemName: "minus.circle")
                            }
                        }
                    }
                    .onDelete(perform: self.swipeRemoveAuthorName)
                }
            }
            
            HStack {
                TextField("author", text: $author)
                Spacer()
                Button(action: { self.addAuthorName(name: self.author) }) {
                    Image(systemName: "plus.circle")
                }
                .disabled(self.author == "")
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            VStack {
                Form {
                    self.searchTitle()
                    
                    self.searchAuthors()
                }
            }
            .navigationBarTitle("Search to Add", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    // SUBMIT FORM
    func addBook() {
        // get book list from Google Books API
        guard let googleBookList = GoogleBooksHelper.getFromGoogle(title: self.title, authors: self.authors) else {
            Debug.debug(msg: "Could not parse Google Books API response into object", level: .error)
            self.error = ErrorAlert(reason: "No Books Found")
            return
        }
        
        DispatchQueue.main.async {
            AddBySearchForm.searchResults = googleBookList
            
            print("search results \(AddBySearchForm.searchResults.books.count)")
            for result in AddBySearchForm.searchResults.books {
                print("-- \(result.title)")
            }
            
            self.env.topView = .googleresults
        }
    }
}

struct AddBySearchForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var env = Env()
    
    static var previews: some View {
        AddBySearchForm(showForm: $showForm)
        .environmentObject(self.env)
    }
}
