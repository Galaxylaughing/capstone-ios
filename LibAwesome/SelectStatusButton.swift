//
//  SelectStatusButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SelectStatusButton: View {
    @EnvironmentObject var env: Env
    
    var selectedStatus: Status?
//    var isDefault: Bool = false // true if the text is not a Status
    var text: String
    var selectAction: () -> ()
    
    fileprivate func isSelectedItem() -> Bool {
        return (self.selectedStatus != nil
                && self.selectedStatus!.getHumanReadableStatus() == self.text)
//            || (self.selectedStatus == nil
//                && self.env.selectedStatusFilter == nil
//                && self.env.selectedRatingFilter == nil
//                && self.isDefault)
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

struct SelectStatusButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectStatusButton(
            selectedStatus: Status.completed,
            text: Status.completed.getHumanReadableStatus(),
            selectAction: {
                print("ok")
            }
        )
        .environmentObject(Env())
    }
}
