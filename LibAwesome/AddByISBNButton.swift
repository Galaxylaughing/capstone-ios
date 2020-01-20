//
//  AddByISBNButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddByISBNButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            HStack {
                Text("enter ISBN")
                Image(systemName: "barcode")
            }
        }
        .sheet(isPresented: $showForm) {
            AddByISBNForm(showForm: self.$showForm)
                .environmentObject(self.env)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct AddByISBNButton_Previews: PreviewProvider {
    static var previews: some View {
        AddByISBNButton()
    }
}
