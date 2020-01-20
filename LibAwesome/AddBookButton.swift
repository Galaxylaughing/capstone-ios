//
//  AddBookButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/20/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBookButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            Text("enter book details")
            AddIcon()
        }.sheet(isPresented: $showForm) {
            AddBookForm(showForm: self.$showForm)
                .environmentObject(self.env)
        }
    }
}

struct AddBookButton_Previews: PreviewProvider {
    static var previews: some View {
        AddBookButton()
    }
}
