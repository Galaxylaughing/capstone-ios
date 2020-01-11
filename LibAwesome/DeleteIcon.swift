//
//  DeleteIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DeleteIcon: View {
    var body: some View {
        HStack {
//            Text("delete")
//                .font(.caption)
            Image(systemName: "trash")
        }
    }
}

struct DeleteIcon_Previews: PreviewProvider {
    static var previews: some View {
        DeleteIcon()
    }
}
