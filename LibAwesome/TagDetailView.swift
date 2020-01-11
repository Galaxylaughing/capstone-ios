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
    @State private var showMenu: Bool = false
//    @State var showEditButtons: Bool
    static var showEditButtons: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            
            if TagDetailView.showEditButtons {
                HStack {
                    Text(self.env.tag.name)
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: { self.showMenu.toggle() } ) {
                        if showMenu {
                            Image(systemName: "chevron.down")
                        } else {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding([.top, .leading, .trailing])
            } else {
                HStack {
                    Text(self.env.tag.name)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding([.top, .leading, .trailing])
            }
            
            HStack {
                if showMenu && TagDetailView.showEditButtons {
                    Spacer()
                    HStack {
                        DeleteIcon()
                        Text(" ")
                        EditTagButton()
                    }
                }
            }
            .padding(.trailing)
            
            List {
                ForEach(self.env.tag.books.sorted(by: {$0.title < $1.title})) { book in
                    VStack {
                        NavigationLink(destination: BookDetailView().environmentObject(book)) {
                            Text("\(book.title)")
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
        tag: tag
        )
    
    static var previews: some View {
        TagDetailView(/*showEditButtons: false*/)
            .environmentObject(self.env)
    }
}
