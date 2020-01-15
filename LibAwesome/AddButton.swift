//
//  AddButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    @State var showLabel: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            if self.showLabel {
                Text("Add Book")
            } else {
                AddIcon()
            }
        }.sheet(isPresented: $showForm) {
            AddBookForm(showForm: self.$showForm)
                .environmentObject(self.env)
        }
        .contextMenu() {
            AddBySearchButton()
            AddByISBNButton()
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
