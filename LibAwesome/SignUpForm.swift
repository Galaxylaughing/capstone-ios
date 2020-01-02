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
    @Binding var showSignUp: Bool
    @Binding var signupSuccess: Bool
    
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
                }
                Section {
                    HStack {
                        Text("password")
                        SecureField("password", text: $password)
                            .textContentType(.password)
                    }
                    
                    HStack {
                        Text("retype password")
                        SecureField("password", text: $confirmPassword)
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
                    AlertHelper.alert(reason: error.reason)
                })
                
            }.navigationBarTitle(Text("Sign Up"))
    }
    
    // POST syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    func signupUser() {
        let response = APIHelper.signupUser(username: self.username, password: self.password)
        
        print("caller sees: \(response)")
        
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
        SignUpForm(showSignUp: $showSignUp, signupSuccess: $signupSuccess).environmentObject(User())
    }
}
