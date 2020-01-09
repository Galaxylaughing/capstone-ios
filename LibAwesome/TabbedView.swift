//
//  TabbedView.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TabbedView: View {
    @EnvironmentObject var env: Env
//    @EnvironmentObject var bookList: BookList
    @State private var selection = 0
    
    var checklist = [
        CheckListItem(isChecked: true, content: "fiction"),
        CheckListItem(isChecked: false, content: "non-fiction")
    ]
    
    var body: some View {
        VStack {
//            LogoutButton()
            TabView(selection: $selection){
                LibraryView()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Library")
                        }
                }
                .tag(0)
                Text("Search")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                }
                .tag(1)
                Text("Read Next")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "lightbulb")
                            Text("Read Next")
                        }
                }
                .tag(2)
                Text("Timeline")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Timeline")
                        }
                }
                .tag(3)
            }
        }
    }
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
            .environmentObject(Env.defaultEnv)
            .environmentObject(BookList(books: []))
    }
}
