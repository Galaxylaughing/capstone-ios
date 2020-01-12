//
//  TagDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TagDetailView: View {
    @EnvironmentObject var env: Env
    
    @State private var bookList = BookList(books: [])
    static var showEditButtons: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.env.tag.name)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .padding([.top, .leading, .trailing])
            
            List {
                ForEach(self.env.tag.books.sorted(by: {$0.title < $1.title})) { book in
                    VStack {
                        Button(action: {
                            BookDetailView.book = book
                            self.env.topView = .bookdetail
                        }) {
                            HStack {
                                Text("\(book.title)")
                                Spacer()
                                ArrowRight()
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct TagDetailView_Previews: PreviewProvider {
    static var book1 = BookList.Book(
        id: 1,
        title: "Storm Front",
        authors: [
            "James Butcher"
        ],
        position: 3,
        tags: ["science-fiction"])
    static var book2 = BookList.Book(
        id: 2,
        title: "Fool Moon",
        authors: [
            "James Butcher"
        ],
        position: 2,
        tags: ["science-fiction"])
    static var book3 = BookList.Book(
        id: 3,
        title: "Grave Peril",
        authors: [
            "Jim Butcher"
        ],
        position: 1,
        tags: ["science-fiction"])
    static var bookList = BookList(books: [book1, book2, book3])
    
    static var tag = TagList.Tag(
        name: "fiction/science-fiction",
        books: [book1, book2, book3])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        TagDetailView()
            .environmentObject(self.env)
    }
}
