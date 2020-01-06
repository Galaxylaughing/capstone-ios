//
//  AddButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    @State var showAddForm: Bool = false
    
    var body: some View {
        Button(action: { self.showAddForm.toggle() }) {
            AddBookIcon()
        }.sheet(isPresented: $showAddForm) {
            AddBookForm(showAddForm: self.$showAddForm)
                .environmentObject(self.currentUser)
                .environmentObject(self.bookList)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
