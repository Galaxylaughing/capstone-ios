//
//  EditTagButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditTagButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            EditIcon()
        }.sheet(isPresented: $showForm) {
            EditTagForm(showForm: self.$showForm,
                         tagToEdit: TagList.Tag(
                            name: self.env.tag.name,
                            books: self.env.tag.books))
                .environmentObject(self.env)
        }
    }
}

struct EditTagButton_Previews: PreviewProvider {
    static var previews: some View {
        EditTagButton()
    }
}
