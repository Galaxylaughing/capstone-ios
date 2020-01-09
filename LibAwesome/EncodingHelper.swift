//
//  EncodingHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation
import SwiftUI

struct EncodingHelper {
    // BOOKS
    // parsing JSON example: https://dev.to/jaumevn/parsing-json-with-swift-5-2m40
    static func decodeBookList(str: String) -> BookList? {
        print("I'M DECODING THIS:")
        print(str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceBookList = try? decoder.decode(BookListService.self, from: data!) {
            print("\nI DECODED SUCCESSFULLY INTO SERVICE:")
            print(serviceBookList)
            // map object-ified JSON to goal object
            let bookList = BookList(from: serviceBookList)
            print("\nI DECODED SUCCESSFULLY INTO OBJECT:")
            print(bookList)
            return bookList
        } else {
            print("I FAILED")
        }
        
        print("I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a BookList object
    static func makeBookList(data: String) -> BookList? {
        if let bookList = decodeBookList(str: data) {
            print("\nRESULTING BOOKS:")
            for book in bookList.books {
                print(book, book.title)
            }
            return bookList
        }
        // else
        print("ERROR")
        return nil
    }
    
    // turn JSON into a Book object
    static func makeBook(data: String) -> BookList.Book? {
        if let bookList = decodeBookList(str: data) {
            print("\nRESULTING BOOK:")
            print(bookList.books[0])
            return bookList.books[0]
        }
        // else
        print("ERROR")
        return nil
    }
    
    
    // SERIES
    static func decodeSeriesList(str: String) -> SeriesList? {
        print("I'M DECODING THIS:")
        print(str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceSeriesList = try? decoder.decode(SeriesListService.self, from: data!) {
            print("\nI DECODED SUCCESSFULLY INTO SERVICE:")
            print(serviceSeriesList)
            // map object-ified JSON to goal object
            let seriesList = SeriesList(from: serviceSeriesList)
            print("\nI DECODED SUCCESSFULLY INTO OBJECT:")
            print(seriesList)
            return seriesList
        } else {
            print("I FAILED")
        }
        
        print("I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a SeriesList object
    static func makeSeriesList(data: String) -> SeriesList? {
        if let seriesList = decodeSeriesList(str: data) {
            print("\nRESULTING SERIES:")
            for series in seriesList.series {
                print(series, series.name)
            }
            return seriesList
        }
        // else
        print("makeSeriesList encountered an error")
        return nil
    }

    // turn JSON into a Series object
    static func makeSeries(data: String) -> SeriesList.Series? {
        if let seriesList = decodeSeriesList(str: data) {
            print("\nRESULTING Series:")
            print(seriesList.series[0])
            return seriesList.series[0]
        }
        // else
        print("ERROR")
        return nil
    }
    
    // TAGS
    static func decodeTagList(str: String) -> TagList? {
        print("I'M DECODING THIS:")
        print(str)
        
        let data: Data? = str.data(using: .utf8)
        // create a decoder
        let decoder = JSONDecoder()
        // 'decode' the JSON into it's object equivalent
        if let serviceTagList = try? decoder.decode(TagListService.self, from: data!) {
            print("\nI DECODED SUCCESSFULLY INTO SERVICE:")
            print(serviceTagList)
            // map object-ified JSON to goal object
            let tagList = TagList(from: serviceTagList)
            print("\nI DECODED SUCCESSFULLY INTO OBJECT:")
            print(tagList)
            return tagList
        } else {
            print("I FAILED")
        }
        
        print("I'M ABOUT TO RETURN")
        return nil
    }
    
    // turn JSON into a TagList object
    static func makeTagList(data: String) -> TagList? {
        if let tagList = decodeTagList(str: data) {
            print("\nRESULTING TAGS:")
            for tag in tagList.tags {
                print(tag, tag.name)
            }
            return tagList
        }
        // else
        print("makeTagList encountered an error")
        return nil
    }

    // turn JSON into a Tag object
    static func makeTag(data: String) -> TagList.Tag? {
        if let tagList = decodeTagList(str: data) {
            print("\nRESULTING TAGS:")
            print(tagList.tags[0], tagList.tags[0].name)
            return tagList.tags[0]
        }
        // else
        print("ERROR")
        return nil
    }
}
