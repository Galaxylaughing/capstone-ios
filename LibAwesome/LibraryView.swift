//
//  LibraryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    @EnvironmentObject var seriesList: SeriesList
    
    // from krebera's answer about AnyView: https://forums.developer.apple.com/thread/122440
    @State var view: AnyView = AnyView(BookListView())
    
    @State var isDrawerBackDropOpen: Bool = false
    @State var isDrawerOpen: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
//                BookListView()
                self.view
                    .navigationBarTitle("Library", displayMode: .large)
                    // nav drawer from https://www.iosapptemplates.com/blog/swiftui/navigation-drawer-swiftui
                    .navigationBarItems(leading: Button(action: {
                        // toggle drawer open after 0.2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isDrawerBackDropOpen.toggle()
                            self.isDrawerOpen.toggle()
                        }
                    }) {
                            Image(systemName: "slider.horizontal.3")
                        },
                        trailing: LogoutButton())
            }
            DrawerBackDrop(isOpen: self.isDrawerBackDropOpen)
                .onTapGesture {
                    if self.isDrawerOpen {
                        self.isDrawerBackDropOpen.toggle()
                        self.isDrawerOpen.toggle()
                    }
                }
//            NavDrawer(isOpen: self.isDrawerOpen, parentView: self.$view)
                .overlay( NavDrawer(isOpen: self.isDrawerOpen, parentView: self.$view) )
        }
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var exampleBook1 = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    static var exampleBook2 = BookList.Book(
        id: 2,
        title: "A Great and Terrible Beauty",
        authors: [
            "Libba Bray"
    ])
    static var bookList = BookList(books: [exampleBook1, exampleBook2])
    
    static var previews: some View {
        LibraryView()
            .environmentObject(bookList)
    }
}
