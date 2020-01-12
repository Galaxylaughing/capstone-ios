//
//  DeleteBookButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DeleteBookButton: View {
    @EnvironmentObject var env: Env
    
    @State private var error: String?
    @State private var showConfirm = false
    
    var body: some View {
        Button(action: { self.displayConfirm() }) {
            DeleteIcon()
        }
        .alert(isPresented: self.$showConfirm) {
            if self.error == nil {
                return Alert(title: Text("Delete '\(BookDetailView.book.title)'"),
                             message: Text("Are you sure?"),
                             primaryButton: .destructive(Text("Delete")) {
                                self.swipeDeleteBook()
                    },
                             secondaryButton: .cancel()
                )
            } else {
                return Alert(title: Text("Error"),
                             message: Text(error!),
                             dismissButton: Alert.Button.default(
                                Text("OK"), action: {
                                    self.error = nil
                                    self.showConfirm = false
                             }
                    )
                )
            }
        }
    }
    
    func displayConfirm() {
        self.showConfirm = true
    }
    
    func swipeDeleteBook() {
        self.showConfirm = false
        // make DELETE request
        let response = APIHelper.deleteBook(token: self.env.user.token, bookId: BookDetailView.book.id)
        if response["success"] != nil {
            // remove book from environment
            if let indexToDelete = self.env.bookList.books.firstIndex(where: {$0.id == BookDetailView.book.id}) {
                let bookList = self.env.bookList
                bookList.books.remove(at: indexToDelete)
                Env.setEnv(in: self.env, to: bookList)
                // return the view to previous position
                NavView.goBack(env: self.env)
            }
        } else if response["error"] != nil {
            self.error = response["error"]!
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        } else {
            self.error = "Unknown error"
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        }
    }
}

struct DeleteBookButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteBookButton()
    }
}
