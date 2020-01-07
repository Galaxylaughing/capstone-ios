//
//  SeriesList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

class SeriesList: ObservableObject {
    @Published var series: [Series]
    
    class Series: Comparable, Identifiable, ObservableObject {
        var id: Int
        @Published var name: String
        @Published var plannedCount: Int
        @Published var books: [Int]
        
        // conform to Comparable
        static func < (lhs: Series, rhs: Series) -> Bool {
            return lhs.name < rhs.name
        }
        static func == (lhs: Series, rhs: Series) -> Bool {
            return lhs.name == rhs.name
        }
        
        // init
        init(id: Int, name: String, plannedCount: Int, books: [Int]) {
            self.id = id
            self.name = name
            self.plannedCount = plannedCount
            self.books = books
        }
    }
    
    init(seriesList: SeriesList) {
        self.series = seriesList.series
    }
    
    init(series: [Series]) {
        self.series = series
    }
    
    init(from service: SeriesListService) {
        series = []
        
        let items = service.series
        for item in items {
            
            var books: [Int] = []
            for book_id in item.books {
                let book = book_id
                books.append(book)
            }
            
            let seriesItem = SeriesList.Series(
                id: item.id,
                name: item.name,
                plannedCount: item.planned_count,
                books: books
            )
            
            series.append(seriesItem)
        }
    }
}

// an object to match the JSON structure
struct SeriesListService: Decodable {
    let series: [Series]
    
    struct Series: Codable {
        let id: Int
        let name: String
        let planned_count: Int
        let books: [Int]
    }
}
