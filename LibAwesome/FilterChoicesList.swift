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
    
    @Binding var selectedSort: Sort
    
    var body: some View {
        Form {
            List() {
                Section {
                    SelectAllButton(
                        text: "Show All",
                        selectAction: {
                            self.env.selectedStatusFilter = nil
                            self.env.selectedRatingFilter = nil
                            self.showOptions = false
                        }
                    )
                }
                
                Section(header: Text("Sort by \(self.selectedSort.method.rawValue)")) {
                    Picker(selection: $selectedSort, label: Text("Sort List"), content: {
                            Text("Sort by Title").tag(Sort(method: .title))
                            Text("Sort by Date").tag(Sort(method: .date))
                    }).pickerStyle(SegmentedPickerStyle())
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
    @State static var sortMethod: Sort = Sort(method: .title)
    
    static var previews: some View {
        FilterChoicesList(
            showOptions: self.$showOptions,
            selectedSort: self.$sortMethod
        )
        .environmentObject(Env())
    }
}
