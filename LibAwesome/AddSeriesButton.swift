//
//  AddSeriesButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddSeriesButton: View {
    @EnvironmentObject var env: Env
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var seriesList: SeriesList
    @State var showSeriesForm: Bool = false
    @State var showLabel: Bool = false
    
    var body: some View {
        Button(action: { self.showSeriesForm.toggle() }) {
            if self.showLabel {
                Text("Add Series")
            } else {
                AddIcon()
            }
        }.sheet(isPresented: $showSeriesForm) {
            AddSeriesForm(showSeriesForm: self.$showSeriesForm)
                .environmentObject(self.env)
//                .environmentObject(self.currentUser)
//                .environmentObject(self.seriesList)
        }
    }
}

struct AddSeriesButton_Previews: PreviewProvider {
    static var previews: some View {
        AddSeriesButton()
    }
}
