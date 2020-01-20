//
//  SignUpForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SignUpForm: View {
    @Binding var showSignUp: Bool
    @Binding var signupSuccess: Bool
    
    @State var showPass: Bool = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var error: ErrorAlert?
    
    var body: some View {
        Form {
            HStack {
                Text("username")
                TextField("username", text: $username)
                    .textContentType(.username)
                    .autocapitalization(.none)
            }
            Section(header: HStack {
                Spacer();
                ShowPasswordButton(showPass: self.$showPass)
            }) {
                HStack {
                    Text("password")
                    if self.showPass {
                        TextField("password", text: $password)
                            .autocapitalization(.none)
                            .textContentType(.password)
                    } else {
                        SecureField("password", text: $password)
                            .autocapitalization(.none)
                            .textContentType(.password)
                    }
                }
                
                HStack {
                    Text("retype password")
                    if self.showPass {
                        TextField("password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .textContentType(.password)
                    } else {
                        SecureField("password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .textContentType(.password)
                    }
                }
            }
            
            Button(action: { self.checkPasswordsMatch() }) {
                HStack {
                    Spacer()
                    Text("Create Account")
                    Spacer()
                }
            }.alert(item: $error, content: { error in
                AlertHelper.alert(reason: error.reason)
            })
            
        }
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }
    
    func checkPasswordsMatch() {
        if self.password != self.confirmPassword {
            self.error = ErrorAlert(reason: "Passwords don't match")
        } else {
            self.signupUser()
        }
    }
    
    // POST syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    func signupUser() {
        let response = APIHelper.signupUser(username: self.username, password: self.password)
        
        if let _ = response["success"] {
            // set signup success message
            self.signupSuccess = true
            // take user back to login page
            self.showSignUp = false
        } else if let errorData = response["error"] {
            self.error = ErrorAlert(reason: "\(errorData)")
        } else {
            self.error = ErrorAlert(reason: "other unknown error")
        }
    }
    
}

struct SignUpForm_Previews: PreviewProvider {
    @State static var showSignUp: Bool = true
    @State static var signupSuccess: Bool = false
    
    static var previews: some View {
        SignUpForm(showSignUp: $showSignUp, signupSuccess: $signupSuccess)
    }
}
