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
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var bookList: BookList
//    @EnvironmentObject var seriesList: SeriesList
    @State var showAddForm: Bool = false
    @State var showLabel: Bool = false
    
    var body: some View {
        Button(action: { self.showAddForm.toggle() }) {
            if self.showLabel {
                Text("Add Book")
            } else {
                AddIcon()
            }
        }.sheet(isPresented: $showAddForm) {
            AddBookForm(showAddForm: self.$showAddForm)
                .environmentObject(self.env)
//                .environmentObject(self.currentUser)
//                .environmentObject(self.bookList)
//                .environmentObject(self.seriesList)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
