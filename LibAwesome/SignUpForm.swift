//
//  SignUpForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SignUpForm: View {
    var body: some View {
        VStack {
            LoginIconView()
            
            VStack {
                Text("username")
                Text("password")
                Text("create account")
            }
            .padding(.top)
        }
    }
}

struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        SignUpForm()
    }
}
