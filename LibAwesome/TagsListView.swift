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
    
    @State private var error: String?
    @State private var showConfirm = false
    @State private var tagToDelete: String = ""
    
    
    func tagCount(list: [TagList.Tag], tagindex: Int, subtagindex: Int) -> Int {
        var tagCount: Int = 0
        
        let subtagCount = list[tagindex].subtags.count
        
        if subtagCount == (subtagindex + 1) {
            tagCount = list[tagindex].books.count
        }
        
       return tagCount
    }
    
    func showTag(list: [TagList.Tag], tagindex: Int, subtagindex: Int) -> Bool {
        var showTag: Bool = true
        if tagindex != 0 {
            
            let currTag = list[tagindex]
            let prevTag = list[tagindex - 1]
            
            if prevTag.subtags.count > subtagindex {
                if currTag.subtags[subtagindex] == prevTag.subtags[subtagindex] {
                    showTag = false
                }
            }
        }
        return showTag
    }
    
    var body: some View {
        Group {
            if self.env.tagList.tags.count > 0 {
                ForEach(0 ..< self.env.tagList.tags.count) { tagIndex in
                    Group {
                        ForEach(0 ..< self.env.tagList.tags[tagIndex].subtags.count) { subtagIndex in
                            Group {
                                if self.showTag(list: self.env.tagList.tags, tagindex: tagIndex, subtagindex: subtagIndex) {
                                    
                                    Button(action: {
                                        self.env.tag = self.env.tagList.tags[tagIndex]
                                        self.parentView = AnyView(TagDetailView())
                                        self.isOpen = false
                                    }) {
                                        HStack {
                                            Text(self.env.tagList.tags[tagIndex].subtags[subtagIndex].description)
                                            .offset(x: CGFloat(integerLiteral: subtagIndex * 20))
                                            Spacer()
                                            if self.showCount {
                                                Text("\(self.tagCount(list: self.env.tagList.tags, tagindex: tagIndex, subtagindex: subtagIndex))")
                                            }
                                        }
                                    }
                                .disabled(self.tagCount(list: self.env.tagList.tags, tagindex: tagIndex, subtagindex: subtagIndex) == 0)
                                    
                                }
                            }
                        }
                    }
                    
                }
                .onDelete(perform: self.displayConfirm)
                .alert(isPresented: self.$showConfirm) {
                    if self.error == nil {
                        return Alert(title: Text("Delete '\(self.tagToDelete)'"),
                                     message: Text("Are you sure?"),
                                     primaryButton: .destructive(Text("Delete")) {
                                        self.swipeDeleteTag()
                            },
                                     secondaryButton: .cancel()
                        )
                    } else {
                        return Alert(title: Text("Error"),
                                     message: Text(error!),
                                     dismissButton: Alert.Button.default(
                                        Text("OK"), action: {
                                            self.error = nil
                                            self.showConfirm = false
                                     }
                            )
                        )
                    }
                }
            } else {
                Text("You have no tags yet")
                    .font(.caption)
            }
        }
    }
    
    func displayConfirm(at offsets: IndexSet) {
        print("confirming")
        let tag = env.tagList.tags.sorted(by: {$0 < $1})[offsets.first!]
        self.tagToDelete = tag.name
        self.showConfirm = true
    }
    
    func swipeDeleteTag() {
        self.showConfirm = false
        
        // make DELETE request
        let response = APIHelper.deleteTag(token: self.env.user.token, tagName: self.tagToDelete)

        if response["success"] != nil {
            // remove tag from any book that has that tag
            let allBooks = self.env.bookList
            for book in allBooks.books {
                if let index = book.tags.firstIndex(of: self.tagToDelete) {
                    book.tags.remove(at: index)
                }
            }
            DispatchQueue.main.async {
                self.env.bookList = allBooks
            }

            // remove tag from environment
            if let indexToDelete = self.env.tagList.tags.firstIndex(where: {$0.name == self.tagToDelete}) {
                let tagList = self.env.tagList
                tagList.tags.remove(at: indexToDelete)
                DispatchQueue.main.async {
                    self.env.tagList = tagList
                    
                    // clears tag from environment if it's the one that's been deleted
                    // does not affect parent view if parent view is current tag's detail view
//                    if self.env.tag.name == self.tagToDelete {
//                        self.env.tag = Env.defaultEnv.tag
//                    }
                }
            }
            
            // works but overcompensates; current tag is not cleared when nagivating away from a tag detail view
            if (self.env.tag.name == self.tagToDelete) {
                self.parentView = AnyView(BookListView())
            }
            
        } else if response["error"] != nil {
            self.error = response["error"]!
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        } else {
            self.error = "Unknown error"
            DispatchQueue.main.async {
                self.showConfirm = true
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
        authorList: Env.defaultEnv.authorList,
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
