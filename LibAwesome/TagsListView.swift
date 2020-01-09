//
//  TagsListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TagsListView: View {
    @EnvironmentObject var env: Env
    @Binding var showCount: Bool
    @Binding var parentView: AnyView
    @Binding var isOpen: Bool
    
    var body: some View {
        // sort alphabetically
        ForEach(self.env.tagList.tags.sorted(by: {$0 < $1})) { tag in
            
            Button(action: {
                self.env.tag = tag
                self.parentView = AnyView(TagDetailView())
                self.isOpen = false
            }) {
                 HStack {
                   Text(tag.name)
                   Spacer()
                   if self.showCount { Text("\(tag.books.count)") }
                }
            }
            
            
        }
    }
}

struct TagsListView_Previews: PreviewProvider {
    @State static var view: AnyView = AnyView(BookListView())
    @State static var showCount = true
    @State static var isOpen = true
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
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag)
    
    static var previews: some View {
        VStack {
            List {
                Section(header: Text("My Tags")) {
                    TagsListView(showCount: self.$showCount, parentView: self.$view, isOpen: self.$isOpen)
                        .environmentObject(self.env)
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
