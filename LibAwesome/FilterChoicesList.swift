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
    
    var body: some View {
        Form {
            List() {
                Section {
                    SelectAllButton(
//                        selectedStatus: self.env.selectedStatusFilter,
//                        isDefault: true,
                        text: "Show All",
                        selectAction: {
                            self.env.selectedStatusFilter = nil
                            self.env.selectedRatingFilter = nil
                            self.showOptions = false
                        }
                    )
                }
                
                Section(header: Text("Filter by Status")) {
                    ForEach(Status.getStatusList(), id: \.self) { status in
                        SelectStatusButton(
                            selectedStatus: self.env.selectedStatusFilter,
                            text: status.getHumanReadableStatus(),
                            selectAction: {
                                self.env.selectedStatusFilter = status
                                self.env.selectedRatingFilter = nil
                                self.showOptions = false
                            }
                        )
                    }
                }
                
                Section(header: Text("Filter by Rating")) {
                    ForEach(Rating.getRatingList(), id: \.self) { rating in
                        SelectRatingButton(
                            selectedRating: self.env.selectedRatingFilter,
                            text: rating.getEmojiStarredRating(),
                            selectAction: {
                                self.env.selectedStatusFilter = nil
                                self.env.selectedRatingFilter = rating
                                self.showOptions = false
                            }
                        )
                    }
                }
                
            }
        }
    }
}

struct FilterChoicesList_Previews: PreviewProvider {
    @State static var showOptions: Bool = true
    
    static var previews: some View {
        FilterChoicesList(showOptions: self.$showOptions)
        .environmentObject(Env())
    }
}
