//
//  Alphabetical.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

func Alphabetical(_ list: [String]) -> [String] {
    return list.sorted(by: {$0 < $1})
}

