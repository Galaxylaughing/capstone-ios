//
//  AuthorDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/10/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AuthorDetailView: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var author: AuthorList.Author
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Text(self.author.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            }
            
            Section {
                VStack(alignment: .center) {
                    Text("Books")
                    .font(.headline)
                    .padding(.top)
                    
                    List {
                        ForEach(self.author.books.sorted(by: {$0.title < $1.title})) { book in
                            NavigationLink(destination: BookDetailView().environmentObject(book)) {
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                    
                                    if book.authors.count > 1 {
                                        Text(book.withAuthors(by: self.author.name))
                                        .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Author", displayMode: .inline)
//        .navigationBarItems(trailing: EditSeriesButton().environmentObject(self.series))
    }
}

struct AuthorDetailView_Previews: PreviewProvider {
    static var books: [BookList.Book] = [
        BookList.Book(id: 1, title: "Orchid Smuggling in Napoleonic China", authors: ["Fakey Fake"], tags: ["non-fiction", "historical", "china"]),
        BookList.Book(id: 2, title: "Of Dogs and Cats: A History of Pets", authors: ["Fakey Fake"], tags: ["non-fiction", "domestication"]),
        BookList.Book(id: 3, title: "The Emu War: Facts and Faces", authors: ["Fakey Fake"], tags: ["non-fiction", "australia", "wars"]),
    ]
    static var bookList = BookList(books: books)
    
    static var authors: [AuthorList.Author] = [
        AuthorList.Author(name: "Fakey Fake", books: [books[0], books[1], books[2]]),
    ]
    static var authorList: AuthorList = AuthorList(authors: authors)
    
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: bookList,
        authorList: authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag)
    
    static var previews: some View {
        AuthorDetailView()
        .environmentObject(self.env)
        .environmentObject(self.authors[0])
    }
}
