//
//  SelectRatingButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SelectRatingButton: View {
    var selectedRating: Rating?
    var text: String
    var selectAction: () -> ()
    
    fileprivate func isSelectedItem() -> Bool {
        return (self.selectedRating != nil
                && self.selectedRating!.getEmojiStarredRating() == self.text)
    }
    
    var body: some View {
        Button(action: { self.selectAction() }) {
            HStack {
                Text(self.text)
                    .foregroundColor(self.isSelectedItem() ? Color.primary : Color.blue)
                Spacer()
                
                if self.isSelectedItem() {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.primary)
                }
            }
        }
    }
}

struct SelectRatingButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectRatingButton(
            selectedRating: Rating.four,
            text: Rating.four.getEmojiStarredRating(),
            selectAction: {
                print("ok")
            }
        )
    }
}
