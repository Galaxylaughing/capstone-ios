//
//  TabbedView.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TabbedView: View {
    @EnvironmentObject var bookList: BookList
    @State private var selection = 0
    
    var body: some View {
        VStack {
            LogoutButton()
            TabView(selection: $selection){
                LibraryView()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("Library")
                        }
                }
                .tag(0)
                Text("Tags")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Tags")
                        }
                }
                .tag(1)
                HelloWorld()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("Add Entry")
                        }
                }
                .tag(2)
                Text("Read Next")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Read Next")
                        }
                }
                .tag(3)
                Text("Timeline")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("Timeline")
                        }
                }
                .tag(4)
            }
        }
    }
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
            .environmentObject(BookList(books: []))
    }
}
