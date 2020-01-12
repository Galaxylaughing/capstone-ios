//
//  DrawerContent.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DrawerContent: View {
    @EnvironmentObject var env: Env
    @Binding var parentView: AnyView
    @Binding var isOpen: Bool
    
    @State private var showCount: Bool = true
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("My Library")) {
                    Button(action: {
                        self.parentView = AnyView(BookListView())
                        self.isOpen = false
                    }) {
                        HStack {
                            Text("Books")
                            // Spacer()
                            // Image(systemName: "checkmark")
                        }
                    }
                    
                    Button(action: {
                        self.parentView = AnyView(AuthorListView())
                        self.isOpen = false
                    }) {
                        HStack {
                            Text("Authors")
                            // Spacer()
                            // Image(systemName: "checkmark")
                        }
                    }
                    
                    Button(action: {
                        self.parentView = AnyView(SeriesListView())
                        self.isOpen = false
                    }) {
                        HStack {
                            Text("Series")
                            // Spacer()
                            // Image(systemName: "checkmark")
                        }
                    }
                }
                
                Section(header: HStack {
                    Text("My Tags");
                    Spacer();
                    ShowTagCountButton(showCount: self.$showCount)
                }) {
                    TagsListView(showCount: self.$showCount, parentView: self.$parentView, isOpen: self.$isOpen)
                }
                
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}

struct DrawerContent_Previews: PreviewProvider {
    @State static var parentView: AnyView = AnyView(BookListView())
    @State static var isOpen = true
    
    static var authors: [AuthorList.Author] = [
        AuthorList.Author(name: "Fakey Fake", books: []),
        AuthorList.Author(name: "Daley Fake", books: []),
        AuthorList.Author(name: "Elizabeth Dunn", books: [])
    ]
    static var authorList: AuthorList = AuthorList(authors: authors)
    
    static var tag0 = TagList.Tag(
        name: "non-fiction",
        books: [])
    static var tag1 = TagList.Tag(
        name: "fantasy",
        books: [])
    static var tag2 = TagList.Tag(
        name: "science-fiction",
        books: [])
    static var tag3 = TagList.Tag(
        name: "mystery",
        books: [])
    static var tag4 = TagList.Tag(
        name: "fantasy/contemporary",
        books: [])
    static var tagList = TagList(tags: [tag0, tag1, tag2, tag3, tag4])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: Env.defaultEnv.bookList,
        authorList: authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        DrawerContent(parentView: self.$parentView, isOpen: $isOpen)
            .environmentObject(self.env)
    }
}
