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
    
    @State private var error: ErrorAlert?
    
    var body: some View {
        Button(action: { self.addBook() }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.green)
        }
        .alert(item: $error, content: { error in
            AlertHelper.alert(reason: error.reason)
        })
    }
    
    func addBook() {
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
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
         
    }
}

struct AddResultButton_Previews: PreviewProvider {
    static var previews: some View {
        AddResultButton(book: BookList.Book())
    }
}
