//
//  SignUpForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SignUpForm: View {
    @EnvironmentObject var currentUser: User
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var error: ErrorAlert?
    
    var body: some View {
            Form {
                Section {
                    HStack {
                        Text("username")
                        TextField("username", text: $username)
                            .textContentType(.username)
                    }
                }
                Section {
                    HStack {
                        Text("password")
                        SecureField("password", text: $password)
                            .textContentType(.password)
                    }
                    
                    HStack {
                        Text("retype password")
                        SecureField("password", text: $password)
                            .textContentType(.password)
                    }
                }
                
                Button(action: { self.signupUser() }) {
                    HStack {
                        Spacer()
                        Text("Create Account")
                        Spacer()
                    }
                }.alert(item: $error, content: { error in
                    alert(reason: error.reason)
                })
                
            }.navigationBarTitle(Text("Sign Up"))
    }
    
    // alert structure from https://goshdarnswiftui.com/
    func alert(reason: String) -> Alert {
        Alert(title: Text("Error"),
                message: Text(reason),
                dismissButton: .default(Text("OK"))
        )
    }
    
    func signupUser() {
        print("signing up")
    }
}

struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        SignUpForm()
    }
}
