//
//  SelectAllButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SelectAllButton: View {
    @EnvironmentObject var env: Env
    
    var text: String
    var selectAction: () -> ()
    
    fileprivate func isSelectedItem() -> Bool {
        return (self.env.selectedStatusFilter == nil
                && self.env.selectedRatingFilter == nil)
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

struct SelectAllButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllButton(
            text: "Show All",
            selectAction: {
                print("show all")
            }
        )
    }
}
