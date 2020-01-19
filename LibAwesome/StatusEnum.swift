//
//  StatusEnum.swift
//  LibAwesome
//
//  Created by Sabrina on 1/16/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation

/* Django Book Model
WANTTOREAD = 'WTR'
CURRENT = 'CURR'
COMPLETED = 'COMP'
PAUSED = 'PAUS'
DISCARDED = 'DNF'
STATUS_CHOICES = [
    (WANTTOREAD, 'Want to Read'),
    (CURRENT, 'Currently Reading'),
    (COMPLETED, 'Completed'),
    (PAUSED, 'Paused'),
    (DISCARDED, 'Discarded'),
]
*/

enum Status: String {
    case wanttoread = "WTR"
    case current = "CURR"
    case completed = "COMP"
    case paused = "PAUS"
    case discarded = "DNF"
    
    static func getStatusList() -> Array<Status> {
        return [
            Status.wanttoread,
            Status.current,
            Status.completed,
            Status.paused,
            Status.discarded
        ]
    }
    
    static let statusTranslator: [Status:String] = [
        Status.wanttoread: "Want to Read",
        Status.current: "Currently Reading",
        Status.completed: "Completed",
        Status.paused: "Paused",
        Status.discarded: "Discarded"
    ]
    func getHumanReadableStatus() -> String {
        return Status.statusTranslator[self] ?? "[unknown status]"
    }
}
