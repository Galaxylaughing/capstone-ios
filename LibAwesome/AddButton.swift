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
//        NavigationLink(destination: AddBookForm()) {
        Button(action: { self.showAddForm.toggle() }) {
            ZStack {
                Image(systemName: "book")
                    .resizable()
                    .frame(width: 40, height: 40)
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .offset(x: 15.0, y: 15.0)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .offset(x: 15.0, y: 15.0)
    //                .frame(width: 70, height: 70)
            }
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
