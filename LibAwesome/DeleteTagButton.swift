//
//  DeleteTagButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DeleteTagButton: View {
    @EnvironmentObject var env: Env
    
    @State private var error: String?
    @State private var showConfirm = false
    
    var body: some View {
        Button(action: { self.displayConfirm() }) {
            DeleteIcon()
        }.alert(isPresented: self.$showConfirm) {
            if self.error == nil {
                return Alert(title: Text("Delete '\(self.env.tag.name)'"),
                             message: Text("Are you sure?"),
                             primaryButton: .destructive(Text("Delete")) {
                                self.deleteTag()
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

    func deleteTag() {
        self.showConfirm = false
        // make DELETE request
        let cleanTagName = EncodingHelper.encodeTagName(tagName: self.env.tag.name)
        Debug.debug(msg: "DELETING: \(cleanTagName)", level: .verbose)
        let response = APIHelper.deleteTag(token: self.env.user.token, tagName: cleanTagName)
        if response["success"] != nil {
            // remove tag from any book that has that tag
            let allBooks = self.env.bookList
            for book in allBooks.books {
                if let index = book.tags.firstIndex(of: self.env.tag.name) {
                    book.tags.remove(at: index)
                }
            }
            DispatchQueue.main.async {
                self.env.bookList = allBooks
            }
            // remove tag from environment
            if let indexToDelete = self.env.tagList.tags.firstIndex(where: {$0.name == self.env.tag.name}) {
                let tagList = self.env.tagList
                tagList.tags.remove(at: indexToDelete)
                DispatchQueue.main.async {
                    self.env.tagList = tagList
                    // clears tag from environment if it's the one that's been deleted
                    self.env.tag = Env.defaultEnv.tag
                    // return the view to previous position
                    NavView.goBack(env: self.env)
                }
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

struct DeleteTagButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteTagButton()
    }
}
