//
//  FilterChoicesButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/18/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct FilterChoicesButton: View {
    @EnvironmentObject var env: Env
    @State var showOptions: Bool = false
    
    @Binding var selectedSort: Sort
    
    var body: some View {
        Button(action: { self.showOptions.toggle() }) {
            HStack {
                Text("Filter")
                Spacer()
                HStack {
                    if self.env.selectedStatusFilter != nil {
                        Text("\(self.env.selectedStatusFilter!.getHumanReadableStatus()) ")
                    } else if self.env.selectedRatingFilter != nil {
                        Text("\(self.env.selectedRatingFilter!.getEmojiStarredRating()) ")
                    } else {
                        Text("Show All ")
                    }
                    ArrowRight()
                }
                .foregroundColor(Color.gray)
            }
        }.sheet(isPresented: self.$showOptions) {
            FilterChoicesList(
                showOptions: self.$showOptions,
                selectedSort: self.$selectedSort
            )
            .environmentObject(self.env)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct FilterChoicesButton_Previews: PreviewProvider {
    static func makeEnv() -> Env {
        let previewEnv = Env()
        previewEnv.selectedStatusFilter = Status.completed
        return previewEnv
    }
    static var env = makeEnv()
    @State static var sortMethod = Sort(method: .title)
    
    static var previews: some View {
        FilterChoicesButton(selectedSort: self.$sortMethod)
            .environmentObject(self.env)
    }
}
