//
//  ContentView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/1/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        HStack {
            if self.env.user.token != nil {
                TabbedView()
                .onAppear {
                    CallAPI.getBooks(env: self.env)
                    CallAPI.getSeries(env: self.env)
                }
            } else {
                LoginForm()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
        .environmentObject(Env.defaultEnv)
    }
}
