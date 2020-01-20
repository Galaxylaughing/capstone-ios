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
    @State var showForm: Bool = false
    @State var showLabel: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            if self.showLabel {
                Text("Add Series")
            } else {
                AddIcon()
            }
        }.sheet(isPresented: $showForm) {
            AddSeriesForm(showForm: self.$showForm)
                .environmentObject(self.env)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct AddSeriesButton_Previews: PreviewProvider {
    static var previews: some View {
        AddSeriesButton()
    }
}
