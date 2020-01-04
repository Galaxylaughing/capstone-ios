//
//  BookDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookDetailView: View {
    let book: BookList.Book
    
    var body: some View {
        VStack {
            Text(book.title)
            Text(book.authorNames())
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            BookList.Book.Author(name: "Neil Gaiman"),
            BookList.Book.Author(name: "Terry Pratchett"),
    ])
    
    static var previews: some View {
        BookDetailView(book: exampleBook)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}
