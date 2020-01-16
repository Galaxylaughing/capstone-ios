//
//  MassDeleteIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/15/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct MassDeleteIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
            Image(systemName: "trash.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
        }
        .padding(10)
    }
}

struct MassDeleteIcon_Previews: PreviewProvider {
    static var previews: some View {
        MassDeleteIcon()
    }
}
