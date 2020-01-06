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
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Button(action: { self.parentView = AnyView(BookListView()) }) {
                    Text("Books")
                        .foregroundColor(Color.white)
                }
                Button(action: { self.parentView = AnyView(SeriesListView()) }) {
                    Text("Series")
                        .foregroundColor(Color.white)
                }
                Button(action: { self.parentView = AnyView(TagsView()) }) {
                    Text("Tags")
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }
    }
}

struct DrawerContent_Previews: PreviewProvider {
    @State static var parentView: AnyView = AnyView(TagsView())
    
    static var previews: some View {
        DrawerContent(parentView: self.$parentView)
    }
}
