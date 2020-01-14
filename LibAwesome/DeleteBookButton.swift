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
                return Alert(title: Text("Delete '\(self.env.book.title)'"),
                             message: Text("Are you sure?"),
                             primaryButton: .destructive(Text("Delete")) {
                                self.deleteBook()
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
    
    func deleteBook() {
        self.showConfirm = false
        // make DELETE request
        let response = APIHelper.deleteBook(token: self.env.user.token, bookId: self.env.book.id)
        if response["success"] != nil {
            // remove book from environment
            if let indexToDelete = self.env.bookList.books.firstIndex(where: {$0.id == self.env.book.id}) {
                let bookList = self.env.bookList
                bookList.books.remove(at: indexToDelete)

                let currentTags = self.env.book.tags
                for currentTag in currentTags {
                    // remove book from tag
                    if let tag = self.env.tagList.tags.first(where: {$0.name == currentTag}) {
                        if let index = tag.books.firstIndex(where: {$0.id == self.env.book.id}) {
                            tag.books.remove(at: index)
                        }
                    }
                }
                
                let envTag = self.env.tag
                for book in envTag.books {
                    if book.id == self.env.book.id {
                        // remove book from envTag
                        if let index = envTag.books.firstIndex(where: {$0.id == book.id}) {
                            envTag.books.remove(at: index)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.env.tag = TagList.Tag(name: envTag.name, books: envTag.books)
                }
                
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
