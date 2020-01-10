//
//  CheckList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct CheckListRow: View {
    @State var item: CheckListItem
    @State var isChecked: Bool
    
    var body: some View {
        HStack {
            if self.isChecked {
                Image(systemName: "checkmark.square.fill")
            } else {
                Image(systemName: "square")
            }
            Text(self.item.content)
        }
        .gesture(
            TapGesture().onEnded({
                // toggle item to update CheckList view
                self.item.isChecked.toggle();
                // toggle boolean to update self view
                self.isChecked.toggle();
            })
        )
    }
}

class CheckListItem: Identifiable, Comparable {
    var id: String {
        return content
    }
    var isChecked: Bool
    var content: String
    var identifier: Int?
    
    init(isChecked: Bool = false, content: String, identifier: Int? = nil) {
        self.isChecked = isChecked
        self.content = content
        self.identifier = identifier
    }
    
    // conform to Comparable
    static func < (lhs: CheckListItem, rhs: CheckListItem) -> Bool {
        return lhs.content < rhs.content
    }
    static func == (lhs: CheckListItem, rhs: CheckListItem) -> Bool {
        return lhs.content == rhs.content
    }
}

struct CheckList: View {
    @Binding var list: [CheckListItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(list) { item in
                    CheckListRow(item: item, isChecked: item.isChecked)
                        .gesture(
                            TapGesture().onEnded({
                                item.isChecked.toggle()
                            })
                        )
                }
            }
        }
    }
}

struct CheckList_Previews: PreviewProvider {
    @State static var checklist = [
        CheckListItem(isChecked: true, content: "fiction"),
        CheckListItem(isChecked: false, content: "non-fiction")
    ]
    
    static var previews: some View {
        CheckList(list: self.$checklist)
    }
}
