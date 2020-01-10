//
//  BookUpdate.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookUpdate: View {
    @Binding var bookChecklist: [CheckListItem]
    
    var body: some View {
        Section(header: Text("tagged books")) {
            VStack(alignment: .leading) {
                CheckList(list: self.$bookChecklist)
            }
        }
    }
}

struct BookUpdate_Previews: PreviewProvider {
    @State static var bookChecklist: [CheckListItem] = []
    
    static var previews: some View {
        BookUpdate( bookChecklist: self.$bookChecklist )
    }
}
