//
//  CallAPI.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct CallAPI {
    static func getTags(env: Env) {
        print("I'm going to go get the tags")
        
        let response = APIHelper.getTags(token: env.user.token)
        
        if let data = response["success"] {
            let apiTagList = EncodingHelper.makeTagList(data: data) ?? TagList(tags: [])
            // update the environment variable
            DispatchQueue.main.async {
                env.tagList = apiTagList
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
        
    static func getSeries(env: Env) {
        let response = APIHelper.getSeries(token: env.user.token)
        
        if let data = response["success"] {
            let apiSeriesList = EncodingHelper.makeSeriesList(data: data) ?? SeriesList(series: [])
            // update the environment variable
            DispatchQueue.main.async {
                env.seriesList = apiSeriesList
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
    
    static func getBooks(env: Env) {
        let response = APIHelper.getBooks(token: env.user.token)
        
        if let data = response["success"] {
            let apiBookList = EncodingHelper.makeBookList(data: data) ?? BookList(books: [])
            // update the environment variable
            DispatchQueue.main.async {
                env.bookList = apiBookList
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
    
    static func updateTags(env: Env) {
        CallAPI.getTags(env: env)
    }
}
