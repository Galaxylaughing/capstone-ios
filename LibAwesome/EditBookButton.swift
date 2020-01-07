//
//  EditBookButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditBookButton: View {
    @EnvironmentObject var env: Env
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var bookList: BookList
    
    @EnvironmentObject var book: BookList.Book
    @State var showEditForm: Bool = false
    
    var body: some View {
        Button(action: { self.showEditForm.toggle() }) {
            HStack {
                Text("edit")
                    .font(.caption)
                Image(systemName: "pencil")
            }
        }.sheet(isPresented: $showEditForm) {
//            EditBookForm(showEditForm: self.$showEditForm, bookToEdit: BookList.Book(id: self.book.id, title: self.book.title, authors: self.book.authors))
            EditBookForm(showEditForm: self.$showEditForm, bookToEdit: BookList.Book(id: self.book.id, title: self.book.title, authors: self.book.authors))
                .environmentObject(self.env)
                .environmentObject(self.book)
//                .environmentObject(self.currentUser)
//                .environmentObject(self.bookList)
        }
    }
}

struct EditBookButton_Previews: PreviewProvider {
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    
    static var previews: some View {
        EditBookButton()
            .environmentObject(self.exampleBook)
    }
}
