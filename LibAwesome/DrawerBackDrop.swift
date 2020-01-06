//
//  DrawerBackDrop.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DrawerBackDrop: View {
    // make DrawerBackDrop full screen width
    private let width = UIScreen.main.bounds.width
    let isOpen: Bool
    
    var body: some View {
        Color(.white)
            .opacity(0.1)
            .frame(width: self.width)
            .offset(x: self.isOpen ? 0 : -self.width) // slide away if closed
            .animation(.default)
    }
}

struct DrawerBackDrop_Previews: PreviewProvider {
    static var previews: some View {
        DrawerBackDrop(isOpen: true)
    }
}
