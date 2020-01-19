//
//  BookHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct BookHelper {
    
    static func filterByStatus(list: [BookList.Book], status: Status) -> [BookList.Book] {
//        var filteredList: [BookList.Book] = []
//
//        for book in list {
//            if book.current_status == status {
//                filteredList.append(book)
//            }
//        }
//
//        return filteredList
        return list.filter { $0.current_status == status }
    }
    
    static func getSeriesId(
        seriesList: SeriesList,
        assignSeries: Bool,
        seriesPositions: [Int],
        seriesPositionIndex: Int,
        seriesIndex: Int) -> [String:Int?] {
        
        var position: Int? = nil
        var seriesId: Int? = nil
        
        if assignSeries {
            position = seriesPositions[seriesPositionIndex]
            let seriesIndex = seriesIndex
            // look up series id from index
            seriesId = seriesList.series[seriesIndex].id
        }
        
        return [
            "position": position,
            "seriesId": seriesId
        ]
    }
    
}
