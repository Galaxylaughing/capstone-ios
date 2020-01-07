//
//  DrawerContent.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DrawerContent: View {
    @Binding var parentView: AnyView
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Button(action: {
                    self.parentView = AnyView(BookListView())
                    self.isOpen = false
                }) {
                    Text("Books")
                        .foregroundColor(Color.white)
                }
                Button(action: {
                    self.parentView = AnyView(SeriesListView())
                    self.isOpen = false
                }) {
                    Text("Series")
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }
    }
}

struct DrawerContent_Previews: PreviewProvider {
    @State static var parentView: AnyView = AnyView(BookListView())
    @State static var isOpen = true
    
    static var previews: some View {
        DrawerContent(parentView: self.$parentView, isOpen: $isOpen)
    }
}
