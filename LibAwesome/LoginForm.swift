//
//  LoginForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginForm: View {
    @EnvironmentObject var currentUser: User
    @State private var showSignUp: Bool = false
    @State private var signupSuccess: Bool = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var error: ErrorAlert?
    
    var body: some View {
        NavigationView {
            VStack {
                if self.signupSuccess {
                    Text("Successfully created account.\nPlease login.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.secondary)
                }
                
                Form {
                    HStack {
                        Text("username")
                        TextField("username", text: $username)
                            .textContentType(.username)
                    }
                    HStack {
                        Text("password")
                        SecureField("password", text: $password)
                            .textContentType(.password)
                    }
                    
                    Button(action: { self.loginUser() }) {
                        HStack {
                            Spacer()
                            Text("Login")
                            Spacer()
                        }
                    }.alert(item: $error, content: { error in
                        AlertHelper.alert(reason: error.reason)
                    })
                    
                    Section {
                        NavigationLink(destination: SignUpForm(
                            showSignUp: $showSignUp,
                            signupSuccess: $signupSuccess
                        ), isActive: $showSignUp) {
                            Text("Don't have an account? Sign up")
                        }
                    }
                }
                .navigationBarTitle(Text("LibAwesome"))
                .navigationBarHidden(false)
            }
        }
    }
    
    func loginUser() {
        let response = APIHelper.loginUser(username: self.username, password: self.password)
        
        print("caller sees: \(response)")
        
        if let userToken = response["success"] {
            // from https://stackoverflow.com/questions/57798050/updating-published-variable-of-an-observableobject-inside-child-view
            // Update the value on the main thread
            DispatchQueue.main.async {
                self.currentUser.username = self.username
                self.currentUser.token = userToken
                
                print(self.currentUser)
            }
        } else if let errorData = response["error"] {
            self.error = ErrorAlert(reason: "\(errorData)")
        } else {
            self.error = ErrorAlert(reason: "other unknown error")
        }
    }
    
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
            .environmentObject(User())
    }
}
