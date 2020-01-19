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
    
    func getDescendantName(tagName: String) -> String {
        let parentTagName = self.env.tag.name
        let nested = tagName[parentTagName.endIndex..<tagName.endIndex]
        
        return String(nested)
    }
    
    func getOtherTagNames(tagName: String) -> String {
        var text: String = ""
        if tagName.contains(self.env.tag.name) {
            text = self.getDescendantName(tagName: tagName)
        } else {
            text = tagName
        }
        
        // swap underscores for slashes
        text = EncodingHelper.decodeTagName(tagName: text)
        
        return text
    }
    
    func listAssociatedTags(book: BookList.Book) -> AnyView {
        return AnyView(
            ForEach(book.tags, id: \.self) { tag in
                VStack {
                    if tag != self.env.tag.name {
                        Text(self.getOtherTagNames(tagName: tag))
                            .font(.caption)
                    }
                }
            }
        )
    }

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
                            self.env.book = book
                            self.env.topView = .bookdetail
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(book.title)")
                                    
                                    VStack(alignment: .leading) {
                                        self.listAssociatedTags(book: book)
                                    }
                                }
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
        tags: ["fiction"])
    static var book2 = BookList.Book(
        id: 2,
        title: "Fool Moon",
        authors: [
            "James Butcher"
        ],
        position: 2,
        tags: ["fiction/science-fiction", "fantasy"])
    static var book3 = BookList.Book(
        id: 3,
        title: "Grave Peril",
        authors: [
            "Jim Butcher"
        ],
        position: 1,
        tags: ["fiction/science-fiction"])
    static var bookList = BookList(books: [book1, book2, book3])
    
    static var tag = TagList.Tag(
        name: "fiction",
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
