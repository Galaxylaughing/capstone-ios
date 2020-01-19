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
    @State private var selectedFilter: Int = 0
    
    fileprivate func getSortedAuthorList() -> [AuthorList.Author] {
        var authorlist = self.env.authorList.authors
        if self.selectedFilter == 0 {
            authorlist = authorlist.sorted(by: { $0.name < $1.name })
        } else {
            authorlist = authorlist.sorted(by: { $0.getLastName() < $1.getLastName() })
        }
        return authorlist
    }
    
    var body: some View {
        VStack {
            Section {
                Picker(selection: $selectedFilter, label: Text("Sort Author Names"), content: {
                        Text("Sort by First Name").tag(0)
                        Text("Sort by Last Name").tag(1)
                }).pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 10)
            }
            Section {
                List {
                    ForEach(self.getSortedAuthorList()) { author in
                        HStack {
                            Button(action: {
                                AuthorDetailView.author = author
                                self.env.topView = .authordetail
                            }) {
                                HStack {
                                    Text(author.name)
                                    Spacer()
                                    ArrowRight()
                                }
                            }
                        }
                    }
                }
            }
        }
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
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        AuthorListView()
        .environmentObject(self.env)
    }
}
