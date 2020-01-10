//
//  TagList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation


class TagList: ObservableObject {
    @Published var tags: [Tag]
    
    init() {
        self.tags = []
    }
    
    init(tagList: TagList) {
        self.tags = tagList.tags
    }
    
    init(tags: [Tag]) {
        self.tags = tags
    }
    
    init(from source: BookList) {
        var tempTags: [TagList.Tag] = []
        var tagNames: [String] = []
        // go through each book in booklist
        for book in source.books {
            // go through each of that book's tags
            for tag in book.tags {
                // is that tag in the name list?
                if tagNames.contains(tag) {
                    // find this tag in the temp list add this book to its list of books
                    if let index = tempTags.firstIndex(where: {$0.name == tag}) {
                        tempTags[index].books.append(book)
                    }
                } else {
                    // add this tag to the list of names
                    tagNames.append(tag)
                    // add the tag to the temp list and add this book to its list of books
                    let newTag = TagList.Tag(name: tag, books: [book])
                    tempTags.append(newTag)
                }
            }
        }
        self.tags = tempTags
    }
    
    class Tag: Comparable, Identifiable, ObservableObject {
        @Published var name: String
        @Published var books: [BookList.Book]
        
        init(tag: Tag) {
            self.name = tag.name
            self.books = tag.books
        }
        
        init(name: String, books: [BookList.Book]) {
            self.name = name
            self.books = books
        }
        
        // conform to Comparable
        static func < (lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name < rhs.name
        }
        static func == (lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name == rhs.name
        }
        
        // return list of book ids
        func bookIds() -> [Int] {
            var bookIds: [Int] = []
            for book in self.books {
                bookIds.append(book.id)
            }
            return bookIds
        }
    }
}
