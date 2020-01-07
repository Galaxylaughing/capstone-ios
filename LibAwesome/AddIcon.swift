//
//  AddIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
        }
        .padding(10)
    }
}

struct AddIcon_Previews: PreviewProvider {
    static var previews: some View {
        AddIcon()
    }
}
