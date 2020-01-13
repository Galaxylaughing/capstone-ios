//
//  ISBNHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct ISBNHelper {
    static func cleanIsbn(isbn: String) -> String {
        Debug.debug(msg: "given isbn: \(isbn)", level: .verbose)
        
        var cleanIsbn = ""
        // strip hyphens from isbn
        cleanIsbn = isbn.replacingOccurrences(of: "-", with: "")
        // strip whitespaces from isbn
        cleanIsbn = cleanIsbn.replacingOccurrences(of: " ", with: "")
        
        Debug.debug(msg: "transformed isbn into: \(cleanIsbn)", level: .verbose)
        return cleanIsbn
    }
}
