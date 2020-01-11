//
//  LibraryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    // from krebera's answer about AnyView: https://forums.developer.apple.com/thread/122440
    @State var view: AnyView = AnyView(BookListView())
    
    @State var isDrawerOpen: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                self.view
                    // nav drawer from https://www.iosapptemplates.com/blog/swiftui/navigation-drawer-swiftui
                    .navigationBarItems(leading: Button(action: {
                        // toggle drawer open after 0.2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isDrawerOpen.toggle()
                        }
                    }) {
                            Image(systemName: "slider.horizontal.3")
                        },
                        trailing: LogoutButton())
            }
            if (self.isDrawerOpen) {
                DrawerBackDrop(isOpen: self.isDrawerOpen)
                    .onTapGesture {
                        if self.isDrawerOpen {
                            self.isDrawerOpen.toggle()
                        }
                    }
                NavDrawer(isOpen: self.$isDrawerOpen, parentView: self.$view)
//                .overlay( NavDrawer(isOpen: self.isDrawerOpen, parentView: self.$view) )
            }}
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
