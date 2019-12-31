//
//  LoginForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginForm: View {
    @State var username: String
    @State var password: String
    
    @State private var showAlert = false
    var alert: Alert {
        Alert(title: Text("Logging In"), message: Text(""), dismissButton: .default(Text("Dismiss")))
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("username")
                    TextField("username", text: $username)
                }
                HStack {
                    Text("password")
                    TextField("password", text: $password)
                }
                Button(action: {self.showAlert.toggle()}) {
                    Text("Login")
                }.alert(isPresented: $showAlert, content: { self.alert })
            }.navigationBarTitle(Text("Login"))
        }
    }
    
//    func loginUser() {}
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm(username: "", password: "")
    }
}

// when someone clicks login,
// the app needs to make a POST request to the API's login url
// providing a username and password

// if correct, a JSON of id and username will be returned.
// otherwise, an error message and non-200 status code
