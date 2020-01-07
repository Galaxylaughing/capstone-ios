//
//  NavDrawer.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct NavDrawer: View {
    // make NavDrawer partial screen width
    private let width = UIScreen.main.bounds.width - 50
    @Binding var isOpen: Bool
    
    @Binding var parentView: AnyView
    
    var body: some View {
        HStack {
            DrawerContent(parentView: self.$parentView, isOpen: self.$isOpen)
                .frame(width: self.width)
                .offset(x: self.isOpen ? 0 : -self.width) // slide away if closed
                .animation(.default)
            Spacer()
        }
    }
}

struct NavDrawer_Previews: PreviewProvider {
    @State static var view: AnyView = AnyView(BookListView())
    @State static var isOpen = true
    static var previews: some View {
        NavDrawer(isOpen: self.$isOpen, parentView: self.$view)
    }
}
