//
//  DateHelper.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

struct DateHelper {
    static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    static func getHumanReadableDate(date: Date) -> String {
        let format = DateFormatter()
        format.dateStyle = .long
        return format.string(from: date)
    }
}
