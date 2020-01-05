//
//  BookDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var book: BookList.Book
    
    var body: some View {
        VStack {
            VStack { // title and author
                ForEach(book.findComponents(), id: \.self) { component in
                    VStack {
                        if component == self.book.getMainTitle() {
                            Text(self.book.getMainTitle())
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(component)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                Text(book.authorNames())
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .navigationBarTitle(Text(book.getMainTitle()), displayMode: .inline)
        .navigationBarItems(trailing: EditBookButton().environmentObject(self.book))
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
        BookDetailView()
            .environmentObject(self.exampleBook)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}
