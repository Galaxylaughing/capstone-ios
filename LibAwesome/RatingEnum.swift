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
    
    func getEmojiStarredRating() -> Text {
        let zeroStars = Text("unrated")
        let oneStar = Text("★☆☆☆☆")
        let twoStars = Text("★★☆☆☆")
        let threeStars = Text("★★★☆☆")
        let fourStars = Text("★★★★☆")
        let fiveStars = Text("★★★★★")
        
        var emojiStars = Text("")
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
