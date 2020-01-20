//
//  Sort.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct Sort: Hashable {
    var method: SortMethod
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(method)
    }
    
    enum SortMethod: String {
        case title = "Title"
        case date = "Date"
    }
}
