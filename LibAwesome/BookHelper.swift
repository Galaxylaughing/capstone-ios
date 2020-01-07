//
//  BookHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct BookHelper {
    
    static func getSeriesId(seriesList: SeriesList, assignSeries: Bool, seriesPositions: [Int], seriesPositionIndex: Int, seriesIndex: Int) -> [String:Int?] {
        var position: Int? = nil
        var seriesId: Int? = nil
        
        if assignSeries {
            position = seriesPositions[seriesPositionIndex]
            let seriesIndex = seriesIndex
            // look up series id from index
            seriesId = seriesList.series[seriesIndex].id
            print("series name", seriesList.series[seriesIndex].name)
        }
        
        if position != nil && seriesId != nil {
            print("position", String(position!))
            print("series", String(seriesId!))
        } else {
            print("position: none")
            print("series: none")
        }
        
        return [
            "position": position,
            "series": seriesId
        ]
    }
    
    /*func createBook(env: Env, title: String, authors: [String], assignSeries: Bool, seriesPositions: [Int], seriesPositionIndex: Int, seriesIndex: Int) -> [String:String] {
        var position: Int? = nil
        var seriesId: Int? = nil
        if assignSeries {
            position = seriesPositions[seriesPositionIndex]
            let seriesIndex = seriesIndex
            // look up series id from index
            seriesId = env.seriesList.series[seriesIndex].id
            print("series name", env.seriesList.series[seriesIndex].name)
        }
        
        print("position", String(position!))
        print("series", String(seriesId!))
        
        // make POST to create a book
        let response = APIHelper.postBook(
            token: env.user.token,
            title: title,
            authors: authors,
            position: position,
            seriesId: seriesId)
        
        return response
    }*/
}
