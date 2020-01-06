//
//  AddTitleField.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddTitleField: View {
    @Binding var title: String
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Title *")
                TextField("book title", text: $title)
            }
        }
    }
}

struct AddTitleField_Previews: PreviewProvider {
    @State static var title = "Title"
    
    static var previews: some View {
        AddTitleField(title: self.$title)
    }
}
