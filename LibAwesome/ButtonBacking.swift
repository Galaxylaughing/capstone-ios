//
//  ButtonBacking.swift
//  LibAwesome
//
//  Created by Sabrina on 1/20/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ButtonBacking: View {
    var button: AnyView
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 90, height: 90)
                .foregroundColor(Color.white).opacity(0)
            self.button
        }
    }
}

struct ButtonBacking_Previews: PreviewProvider {
    static var button =  AnyView(BarcodeScanner(showText: false))
    
    static var previews: some View {
        ButtonBacking(button: self.button)
    }
}
