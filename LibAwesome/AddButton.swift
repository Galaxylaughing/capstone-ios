//
//  AddButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.75))
                .frame(width: 70, height: 70)
            Text("+")
                .font(.largeTitle)
                .foregroundColor(Color.white)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
