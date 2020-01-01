//
//  ContentView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/1/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var currentUser: User
    
    var body: some View {
        HStack {
            if currentUser.token != nil {
                TabbedView()
            } else {
                LoginForm()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(User())
    }
}
