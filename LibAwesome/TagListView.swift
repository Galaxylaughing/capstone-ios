//
//  TagListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

//struct TagListView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct TagListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagListView()
//    }
//}


struct TagListView: View {
    @EnvironmentObject var env: Env
    
    @State private var showCount: Bool = true
    
    func isFullTag(list: [TagList.Tag], tagIndex: Int, subtagIndex: Int) -> Bool {
        var isTag = false
        let subtagCount = list[tagIndex].subtags.count
        Debug.debug(msg: "isFullTag --> subtags: \(subtagCount)")
        Debug.debug(msg: "isFullTag --> matches: \(subtagCount == (subtagIndex + 1))")
        if subtagCount == (subtagIndex + 1) {
            isTag = true
        }
        Debug.debug(msg: "isFullTag --> isTag: \(isTag)")
        return isTag
    }
    
    func tagCount(list: [TagList.Tag], tagIndex: Int, subtagIndex: Int) -> Int {
        return self.matchingPrefixes(list: self.env.tagList.tags, tagIndex: tagIndex, subtagIndex: subtagIndex).count
    }
    
    func showTag(list: [TagList.Tag], tagindex: Int, subtagindex: Int) -> Bool {
        var showTag: Bool = true
        if tagindex != 0 {
            
            let currTag = list[tagindex]
            let prevTag = list[tagindex - 1]
            
            print("current tag \(currTag.name)")
            print("previous tag \(prevTag.name)")
            
            if prevTag.subtags.count > subtagindex {
                if currTag.subtags[subtagindex] == prevTag.subtags[subtagindex] {
                    showTag = false
                }
            }
        }
        return showTag
    }
    
    func constructTagName(list: [TagList.Tag], tagIndex: Int, subtagIndex: Int) -> String {
        let tagName = list[tagIndex].subtags[0 ... subtagIndex].joined(separator: "/")
        return tagName
    }
    
    func matchingPrefixes(list: [TagList.Tag], tagIndex: Int, subtagIndex: Int) -> [BookList.Book] {
        // find all tags that start with tagame and add their books to a list
        var matchingBooks: Set<BookList.Book> = []
        let tagName = self.constructTagName(list: list, tagIndex: tagIndex, subtagIndex: subtagIndex) + "/"
        Debug.debug(msg: "FINDING books for tag \(tagName)")
        
        let subtagCount = list[tagIndex].subtags.count
        Debug.debug(msg: "  subtagCount \(subtagCount)")
        
        var i = tagIndex
        for tag in list[tagIndex ..< list.count] {
            Debug.debug(msg: "  TAG at index \(i) \(tag.name)")
            if (list[tagIndex] == tag && subtagCount == (subtagIndex + 1))
                || tag.name.hasPrefix(tagName) {
                Debug.debug(msg: "  matched \(tagName)")
                // add its books to matchingBooks
                for book in tag.books {
                    Debug.debug(msg: "    adding book \(book.title)")
                    matchingBooks.insert(book)
                }
            } else {
                Debug.debug(msg: "  breaking index \(i)")
                break
            }
            i += 1
        }
        Debug.debug(msg: "RETURN")
        return Array(matchingBooks)
    }
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("My Tags");
                Spacer();
                ShowTagCountButton(showCount: self.$showCount)
            }) {
                Group {
                    if self.env.tagList.tags.count > 0 {
                        ForEach(0 ..< self.env.tagList.tags.count, id: \.self) { tagIndex in
                            Group {
                                ForEach(0 ..< self.env.tagList.tags[tagIndex].subtags.count, id: \.self) { subtagIndex in
                                    Group {
                                        if self.showTag(list: self.env.tagList.tags, tagindex: tagIndex, subtagindex: subtagIndex) {
                                            Button(action: {
                                                self.env.tagToEdit = self.env.tagList.tags[tagIndex]
                                                // new tag with name of tag at current index, and books = result of starts with
                                                let newTag = TagList.Tag(
                                                    name: self.constructTagName(list: self.env.tagList.tags, tagIndex: tagIndex, subtagIndex: subtagIndex),
                                                    books: self.matchingPrefixes(list: self.env.tagList.tags, tagIndex: tagIndex, subtagIndex: subtagIndex))
                                                self.env.tag = newTag
                                                TagDetailView.showEditButtons = self.isFullTag(list: self.env.tagList.tags, tagIndex: tagIndex, subtagIndex: subtagIndex)
                                                self.env.topView = .tagdetail
                                            }) {
                                                HStack {
                                                    Text(self.env.tagList.tags[tagIndex].subtags[subtagIndex].description)
                                                        .offset(x: CGFloat(integerLiteral: subtagIndex * 20))
                                                    Spacer()
                                                    if self.showCount {
                                                        Text("\(self.tagCount(list: self.env.tagList.tags, tagIndex: tagIndex, subtagIndex: subtagIndex))")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Text("You have no tags yet")
                            .font(.caption)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct TagListView_Previews: PreviewProvider {
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
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        VStack {
            List {
                Section(header: Text("My Tags")) {
                    TagListView()
                        .environmentObject(self.env)
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
