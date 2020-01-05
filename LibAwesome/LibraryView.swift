//
//  LibraryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    
    var body: some View {
        NavigationView{
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                VStack {
                    // default to sorting alphabetically
                    List(bookList.books.sorted(by: {
                        $0 < $1
                    })) { book in
                        HStack {
                            NavigationLink(destination: BookDetailView(book: book)) {
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                    Text(book.authorNames())
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                AddButton()
                    .padding([.bottom, .trailing])
            }
            .navigationBarTitle("Library", displayMode: .large)
            .navigationBarItems(trailing: LogoutButton())
        }
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var exampleBook1 = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            BookList.Book.Author(name: "Neil Gaiman"),
            BookList.Book.Author(name: "Terry Pratchett"),
    ])
    static var exampleBook2 = BookList.Book(
        id: 2,
        title: "A Great and Terrible Beauty",
        authors: [
            BookList.Book.Author(name: "Libba Bray")
    ])
    static var bookList = BookList(books: [exampleBook1, exampleBook2])
    
    static var previews: some View {
        LibraryView()
            .environmentObject(bookList)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}
