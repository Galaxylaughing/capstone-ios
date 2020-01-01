//
//  LoginView.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            VStack {
                LoginIconView()
                
                LoginForm()
                    .padding(.vertical)
                
                NavigationLink(destination: SignUpForm()) {
                    Text("Don't have an account? Sign up")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
