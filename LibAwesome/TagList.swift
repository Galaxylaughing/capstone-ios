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

    class Tag: Comparable, Identifiable, ObservableObject {
        var id: String {
            return name
        }
        
        @Published var name: String
        @Published var books: [Int]
        
        // conform to Comparable
        static func < (lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name < rhs.name
        }
        static func == (lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name == rhs.name
        }

        // init
        init(name: String, books: [Int]) {
            self.name = name
            self.books = books
        }
    }

    init(tagList: TagList) {
        self.tags = tagList.tags
    }

    init(tags: [Tag]) {
        self.tags = tags
    }

    init(from service: TagListService) {
        tags = []

        let serviceTags = service.tags
        for serviceTag in serviceTags {

            var books: [Int] = []
            for book_id in serviceTag.books {
                books.append(book_id)
            }

            let newTag = TagList.Tag(
                name: serviceTag.tag_name,
                books: books
            )

            tags.append(newTag)
        }
    }
}

// an object to match the JSON structure
struct TagListService: Decodable {
    let tags: [Tag]
    
    struct Tag: Codable {
        let tag_name: String
        let books: [Int]
    }
}
