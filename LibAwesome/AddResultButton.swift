//
//  AddResultButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddResultButton: View {
    @EnvironmentObject var env: Env
    var book: BookList.Book
    
    @State private var error: String = ""
    @State private var showAlert: Bool = false
    @State private var warningTitle: String = ""
    @State private var warningMessage: String = ""
    @State private var proceedAfterWarning: Bool = false
    
    var body: some View {
        Button(action: { self.checkBookResultIsbn() }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.green)
        }
        .alert(isPresented: self.$showAlert) {
            if self.warningMessage != "" {
                return Alert(
                    title: Text(self.warningTitle),
                    message: Text(self.warningMessage),
                    primaryButton: .destructive(Text("Add Book")) {
                        self.warningTitle = ""
                        self.warningMessage = ""
                        self.proceedAfterWarning = true
                        self.showAlert = false
                        self.addBookResultToLibrary()
                    },
                    secondaryButton: .cancel()
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text(self.error),
                    dismissButton: Alert.Button.default(
                        Text("OK"),
                        action: {
                            self.error = ""
                            self.showAlert = false
                        }
                    )
                )
            }
        }
        
    }
    
    func checkBookResultIsbn() {
        var isbnIsPresent = false
        
        if self.book.isbn13 != nil
        && self.book.isbn10 != nil {
            isbnIsPresent = BookHelper.isPresentInList(
                isbn10: self.book.isbn10!,
                isbn13: self.book.isbn13!,
                in: self.env.bookList.books
            )
        } else if self.book.isbn13 != nil {
            isbnIsPresent = BookHelper.isPresentInList(
                isbn: self.book.isbn13!,
                in: self.env.bookList.books
            )
        } else if self.book.isbn10 != nil {
            isbnIsPresent = BookHelper.isPresentInList(
                isbn: self.book.isbn10!,
                in: self.env.bookList.books
            )
        }
        
        if isbnIsPresent {
            self.warningTitle = "This ISBN is already present in your library."
            self.warningMessage = "Are you sure you want to add it?"
            self.showAlert = true
        } else {
            self.addBookResultToLibrary()
        }
    }
    
    func addBookResultToLibrary() {
        // POST selected book to API
        let bookToSend: BookListService.Book = BookListService.Book(from: self.book)
        
        Debug.debug(msg: "\(bookToSend.title)", level: .verbose)
        Debug.debug(msg: "  \(String(describing: bookToSend.position_in_series))", level: .verbose)
        Debug.debug(msg: "  \(String(describing: bookToSend.series))", level: .verbose)
        Debug.debug(msg: "  \(bookToSend.tags)", level: .verbose)
        
        let response = APIHelper.postBook(
            token: self.env.user.token,
            book: bookToSend)

        if response["success"] != nil {
            // add new book to environment BookList
            if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
                let bookList = self.env.bookList
                bookList.books.append(newBook)
                Env.setEnv(in: self.env, to: bookList)
                DispatchQueue.main.async {
                    self.env.book = newBook
                    self.env.topView = .bookdetail
                }
            }
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = response["error"]!
            self.showAlert = true
        } else {
            self.error = "Unknown error"
            self.showAlert = true
        }
         
    }
}

struct AddResultButton_Previews: PreviewProvider {
    static var previews: some View {
        AddResultButton(book: BookList.Book())
    }
}
