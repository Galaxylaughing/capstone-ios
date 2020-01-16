//
//  MassDeleteButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/15/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct MassDeleteButton: View {
    @EnvironmentObject var env: Env
    var itemsToDelete: Set<Int>
    
    @Binding var showConfirm: Bool
    @Binding var error: String?
    
    var body: some View {
        Button(action: { self.deleteListItems() }) {
            MassDeleteIcon()
        }
    }
    
    func deleteListItems() {
        self.showConfirm = false
        
        for id in itemsToDelete {
            let response = APIHelper.deleteBook(token: self.env.user.token, bookId: id)
            
            if response["success"] != nil {
                // proceed to next iteration of for loop
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
        
        // update state
        let tempBooklist = self.env.bookList
        for id in itemsToDelete {
            // find the book
            if let book = tempBooklist.books.first(where: {$0.id == id}) {
                
                // remove book from booklist
                if let index = tempBooklist.books.firstIndex(where: {$0.id == id}) {
                    tempBooklist.books.remove(at: index)
                }
                
                // update tags
                let currentTags = book.tags
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
                
            }
        }
        
        Env.setEnv(in: self.env, to: tempBooklist)
        DispatchQueue.main.async {
            self.env.bookList = tempBooklist
        }
        
    }
}

struct MassDeleteButton_Previews: PreviewProvider {
    @State static var itemsToDelete = Set<Int>()
    
    @State static var error: String?
    @State static var showConfirm: Bool = false
    
    static var previews: some View {
        MassDeleteButton(itemsToDelete: self.itemsToDelete, showConfirm: self.$showConfirm, error: self.$error)
    }
}
