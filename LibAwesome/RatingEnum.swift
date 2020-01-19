//
//  RatingEnum.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import Foundation
import SwiftUI

/* Django Book Model
 UNRATED = 0
 ONE = 1
 TWO = 2
 THREE = 3
 FOUR = 4
 FIVE = 5
 RATING_CHOICES = [
     (UNRATED,   'Unrated'),
     (ONE,       'One'),
     (TWO,       'Two'),
     (THREE,     'Three'),
     (FOUR,      'Four'),
     (FIVE,      'Five'),
 ]
 */

enum Rating: Int {
    case unrated = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    static func getRatingList() -> Array<Rating> {
        return [
            Rating.five,
            Rating.four,
            Rating.three,
            Rating.two,
            Rating.one,
            Rating.unrated,
        ]
    }
    
    func getLongName() -> String {
        var longName = ""
        switch self {
        case .unrated:
            longName = "Unrated"
        case .one:
            longName = "One Star"
        case .two:
            longName = "Two Stars"
        case .three:
            longName = "Three Stars"
        case .four:
            longName = "Four Stars"
        case .five:
            longName = "Five Stars"
        }
        return longName
    }
    
    func getEmojiStarredRating() -> String {
        let zeroStars = "unrated"
        let oneStar = "★☆☆☆☆"
        let twoStars = "★★☆☆☆"
        let threeStars = "★★★☆☆"
        let fourStars = "★★★★☆"
        let fiveStars = "★★★★★"
        
        var emojiStars = ""
        switch self {
        case .unrated:
            emojiStars = zeroStars
        case .one:
            emojiStars = oneStar
        case .two:
            emojiStars = twoStars
        case .three:
            emojiStars = threeStars
        case .four:
            emojiStars = fourStars
        case .five:
            emojiStars = fiveStars
        }
        return emojiStars
    }
    
    func getStarredRating() -> AnyView {
        let filledStarCount = self.rawValue
        let remainingStarCount = (5 - filledStarCount)
        
        let filledStar = Image(systemName: "star.fill").foregroundColor(Color.yellow)
        let emptyStar = Image(systemName: "star").foregroundColor(Color.yellow)
        
        return AnyView(
            HStack {
                if self.rawValue != 0 {
                    ForEach(0..<filledStarCount, id: \.self) { _ in
                        filledStar
                    }
                    ForEach(0..<remainingStarCount, id: \.self) { _ in
                        emptyStar
                    }
                } else {
                    Text("unrated")
                }
            }
        )
    }
}
