//
//  AuthorListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/10/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AuthorListView: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        VStack {
            Section {
                List {
                    ForEach(self.env.authorList.authors) { author in
                        HStack {
                            Text(author.name)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Authors", displayMode: .large)
    }
}

struct AuthorListView_Previews: PreviewProvider {
    static var authors: [AuthorList.Author] = [
        AuthorList.Author(name: "Fakey Fake", books: []),
        AuthorList.Author(name: "Daley Fake", books: []),
        AuthorList.Author(name: "Elizabeth Dunn", books: [])
    ]
    static var authorList: AuthorList = AuthorList(authors: authors)
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: Env.defaultEnv.bookList,
        authorList: authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag)
    
    static var previews: some View {
        AuthorListView()
        .environmentObject(self.env)
    }
}
