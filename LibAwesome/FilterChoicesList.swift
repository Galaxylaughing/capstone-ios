//
//  FilterChoicesList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/18/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct FilterChoicesList: View {
    @EnvironmentObject var env: Env
    @Binding var showOptions: Bool
    
    struct SelectStatusButton: View {
        var selectedStatus: Status?
        var isDefault: Bool = false // true if the text is not a Status
        var text: String
        var selectAction: () -> ()
        
        fileprivate func isSelectedItem() -> Bool {
            return (self.selectedStatus != nil
                    && self.selectedStatus!.getHumanReadableStatus() == self.text)
                || (self.selectedStatus == nil
                    && self.isDefault)
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
    
    var body: some View {
        Form {
            List() {
                SelectStatusButton(
                    selectedStatus: self.env.selectedStatusFilter,
                    isDefault: true,
                    text: "Show All",
                    selectAction: {
                        self.env.selectedStatusFilter = nil
                        self.showOptions = false
                    }
                )
                ForEach(Status.getStatusList(), id: \.self) { status in
                    SelectStatusButton(
                        selectedStatus: self.env.selectedStatusFilter,
                        text: status.getHumanReadableStatus(),
                        selectAction: {
                            self.env.selectedStatusFilter = status
                            self.showOptions = false
                        }
                    )
                }
            }
        }
    }
}

struct FilterChoicesList_Previews: PreviewProvider {
    @State static var showOptions: Bool = true
    
    static var previews: some View {
        FilterChoicesList(showOptions: self.$showOptions)
    }
}
