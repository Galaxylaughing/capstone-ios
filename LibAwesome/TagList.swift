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
        self.tags = TagList.sortTags(tags: tagList.tags)
    }
    
    init(tags: [Tag]) {
        self.tags = TagList.sortTags(tags: tags)
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
                    let cleanTag = /*EncodingHelper.unCleanTagNameForUser(tagName:*/ tag/*)*/
                    // add this tag to the list of names
                    tagNames.append(cleanTag)
                    // add the tag to the temp list and add this book to its list of books
                    let newTag = TagList.Tag(name: cleanTag, books: [book])
                    tempTags.append(newTag)
                }
            }
        }
        self.tags = TagList.sortTags(tags: tempTags)
    }
    
    static func sortTags(tags: [Tag]) -> [Tag] {
        return tags.sorted(by: {$0 < $1})
    }
    
    class Tag: Comparable, Identifiable, ObservableObject {
        @Published var name: String
        @Published var books: [BookList.Book]
        @Published var subtags: [String]
        
        init() {
            self.name = ""
            self.books = []
            self.subtags = []
        }
        
        init(tag: Tag) {
            self.name = tag.name
            self.books = tag.books
            self.subtags = Tag.getSubTags(tag: tag.name)
        }
        
        init(name: String, books: [BookList.Book]) {
            self.name = name
            self.books = books
            self.subtags = Tag.getSubTags(tag: name)
        }
        
        static func getSubTags(tag: String) -> [String] {
            return tag.components(separatedBy: NESTED_TAG_DELIMITER)
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
