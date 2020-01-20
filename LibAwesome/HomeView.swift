//
//  HomeView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    HomeNavButton(view: .booklist, icon: BOOKLIST_ICON)
                    HomeNavButton(view: .authorlist, icon: AUTHORLIST_ICON)
                    HomeNavButton(view: .serieslist, icon: SERIESLIST_ICON)
                }
                
                Spacer()
                TagListView()
                Spacer()
            }
            ButtonBacking(button: AnyView(
                BarcodeScanner(showText: false)
                .contextMenu() {
                    AddBookButton()
                    AddBySearchButton()
                    AddByISBNButton()
                    BarcodeScanner()
                }
            ))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
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
        authorList: Env.defaultEnv.authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        HomeView()
        .environmentObject(self.env)
    }
}
