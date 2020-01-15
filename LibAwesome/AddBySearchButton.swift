//
//  AddBySearchButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBySearchButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            HStack {
                Text("search to add")
                Image(systemName: "magnifyingglass")
            }
        }
        .sheet(isPresented: $showForm) {
            AddBySearchForm(showForm: self.$showForm)
                .environmentObject(self.env)
        }
    }
}

struct AddBySearchButton_Previews: PreviewProvider {
    static var previews: some View {
        AddBySearchButton()
    }
}
