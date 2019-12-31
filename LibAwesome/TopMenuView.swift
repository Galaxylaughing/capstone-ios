//
//  TopMenuView.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TopMenuView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("logout")
            Image("first")
        }
        .padding()
    }
}

struct TopMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuView()
    }
}
