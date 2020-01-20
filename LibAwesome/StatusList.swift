//
//  StatusList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class BookStatusList: ObservableObject {
    @Published var status_history: [BookStatus]
    
    init() {
        self.status_history = []
    }
    
    init(statusList: BookStatusList) {
        self.status_history = statusList.status_history
    }
    
    class BookStatus: Comparable, Identifiable, ObservableObject {
        var id: Int
        let bookId: Int
        @Published var status: Status
        @Published var date: Date
        
        // conform to Comparable
        static func < (lhs: BookStatus, rhs: BookStatus) -> Bool {
            return lhs.date < rhs.date
        }
        static func == (lhs: BookStatus, rhs: BookStatus) -> Bool {
            return lhs.date == rhs.date
        }
        
        init(id: Int,
             bookId: Int,
             status: Status,
             date: Date) {
            self.id = id
            self.bookId = bookId
            self.status = status
            self.date = date
        }
    }
    
    // make bookstatuslist object from API
    init(from service: BookStatusListService) {
        status_history = []
        
        let items = service.status_history
        for item in items {
            
            let formatter = ISO8601DateFormatter()
            let isoDate = formatter.date(from: item.date) ?? Date()
            
            let bookStatus = BookStatusList.BookStatus(
                id: item.id,
                bookId: item.book,
                status: Status(rawValue: item.status_code) ?? Status.wanttoread,
                date: isoDate
            )
            
            status_history.append(bookStatus)
        }
    }
}

// an object to match the API's JSON structure
struct BookStatusListService: Decodable {
    let status_history: [BookStatus]
    
    struct BookStatus: Codable {
        var id: Int
        var status_code: String
        var date: String
        let book: Int
    }
}
