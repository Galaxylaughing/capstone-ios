//
//  AddBookIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddBookIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "book")
                .resizable()
                .frame(width: 40, height: 40)
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .offset(x: 15.0, y: 15.0)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .offset(x: 15.0, y: 15.0)
        }
    }
}

struct AddBookIcon_Previews: PreviewProvider {
    static var previews: some View {
        AddBookIcon()
    }
}
