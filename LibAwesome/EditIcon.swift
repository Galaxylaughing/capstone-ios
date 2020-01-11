//
//  EditIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditIcon: View {
    var body: some View {
        HStack {
//            Text("edit")
//                .font(.caption)
            Image(systemName: "pencil")
        }
    }
}

struct EditIcon_Previews: PreviewProvider {
    static var previews: some View {
        EditIcon()
    }
}
