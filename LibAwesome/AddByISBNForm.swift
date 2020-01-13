//
//  AddByISBNForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddByISBNForm: View {
    @EnvironmentObject var env: Env
    
    @State private var error: ErrorAlert?
    @Binding var showForm: Bool
    
    // form fields
    @State private var isbn: String = ""
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.addBook() }) {
            Text("Add Book")
        }
        // disable if no isbn
        .disabled(self.isbn == "")
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
        NavigationView() {
            VStack {
                Form {
                    Section(
                    header: Text("ISBN"),
                    footer: HStack { Spacer(); Text("accepts ISBN-10 or ISBN-13"); Spacer() }
                    ) {
                        VStack(alignment: .leading) {
                            TextField("isbn", text: $isbn)
                        }
                    }
                }
            }
            .navigationBarTitle("Add With ISBN", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    // SUBMIT FORM
    func addBook() {
        // strip any whitespace or hyphens from isbn
        let cleanIsbn = ISBNHelper.cleanIsbn(isbn: self.isbn)
        
        // get book from Google Books API
        guard let googleBookList = GoogleBooksHelper.getFromGoogle(isbn: cleanIsbn) else {
            Debug.debug(msg: "Could not parse Google Books API response into object", level: .error)
            self.error = ErrorAlert(reason: "ISBN Not Found")
            return
        }
        
        // POST book to API
        let googleBook = googleBookList.books[0]
        let response = APIHelper.postBook(
            token: self.env.user.token,
            title: googleBook.title,
            authors: googleBook.authors,
            position: nil,
            seriesId: nil,
            publisher: googleBook.publisher,
            publicationDate: googleBook.publicationDate,
            isbn10: googleBook.isbn10,
            isbn13: googleBook.isbn13,
            pageCount: googleBook.pageCount,
            description: googleBook.description,
            tags: [])
        
        if response["success"] != nil {
            print("came back from POSTING with success")
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                let bookList = self.env.bookList
                bookList.books.append(newBook)
                Env.setEnv(in: self.env, to: bookList)
                DispatchQueue.main.async {
                    BookDetailView.book = newBook
                    self.env.topView = .bookdetail
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

struct AddByISBNForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var env = Env()
    
    static var previews: some View {
        AddByISBNForm(showForm: $showForm)
            .environmentObject(self.env)
    }
}
