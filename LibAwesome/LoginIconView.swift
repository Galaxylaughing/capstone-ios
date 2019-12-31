//
//  LoginIconView.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginIconView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.black)
                .frame(width: 200, height: 120)
            Text("LibAwesome")
                .font(.title)
                .foregroundColor(.white)
        }
        .padding(.vertical)
    }
}

struct LoginIconView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIconView()
    }
}
