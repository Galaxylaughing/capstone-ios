//
//  LoginForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginForm: View {
    var body: some View {
        VStack {
            LoginIconView()
            
            VStack {
                Text("username")
                Text("password")
                Text("login")
            }
            .padding(.top)
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}
