//
//  CallAPI.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct CallAPI {
    static func getSeries(env: Env) {
        let response = APIHelper.getSeries(token: env.user.token)
        
        if let data = response["success"] {
            let apiSeriesList = EncodingHelper.makeSeriesList(data: data) ?? SeriesList(series: [])
            // update the environment variable
            DispatchQueue.main.async {
                env.seriesList = apiSeriesList
            }
        } else if let errorData = response["error"] {
            Debug.debug(msg: "\(errorData)", level: .error)
        } else {
            Debug.debug(msg: "other unknown error", level: .error)
        }
    }
    
    static func getBooks(env: Env) {
        let response = APIHelper.getBooks(token: env.user.token)
        
        if let data = response["success"] {
            let apiBookList = EncodingHelper.makeBookList(data: data) ?? BookList(books: [])
            
            Debug.debug(msg: "\nCallAPI.getBooks returned from calling makeBookList", level: .verbose)
            Debug.debug(msg: "\nCallAPI.getBooks is about to call getAuthors", level: .verbose)
            let authorList = EncodingHelper.getAuthors(from: apiBookList)
            
            Debug.debug(msg: "\nCallAPI.getBooks returned from calling getAuthors", level: .verbose)
            Debug.debug(msg: "\nCallAPI.getBooks is about to call getTags", level: .verbose)
            let tagList = EncodingHelper.getTags(from: apiBookList)
            
            // update the environment variable
            DispatchQueue.main.async {
                env.bookList = apiBookList
                env.authorList = authorList
                env.tagList = tagList
            }
        } else if let errorData = response["error"] {
            Debug.debug(msg: "\(errorData)", level: .error)
        } else {
            Debug.debug(msg: "other unknown error", level: .error)
        }
    }
}
