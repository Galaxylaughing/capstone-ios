//
//  TagUpdate.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TagUpdate: View {
    @Binding var tagChecklist: [CheckListItem]
    @Binding var newTag: String
    @State var addTag: () -> Void
    
    var body: some View {
        Section(header: Text("add tags")) { // tags
            HStack {
                TextField("add tag", text: $newTag)
                    .autocapitalization(.none)
                Spacer()
                Button(action: { self.addTag() } ) {
                    Image(systemName: "plus.circle")
                }.disabled(self.newTag == "")
            }

            VStack(alignment: .leading) {
                CheckList(list: self.$tagChecklist)
            }
        }
    }
}

struct TagUpdate_Previews: PreviewProvider {
    @State static var tagChecklist: [CheckListItem] = []
    @State static var newTag: String = ""
    
    static func addTag() {
        print("adding")
    }
    
    static var previews: some View {
        TagUpdate(
            tagChecklist: self.$tagChecklist,
            newTag: self.$newTag,
            addTag: { self.addTag() }
        )
    }
}
