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
    
    // POST syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    func signupUser() {
        // Prepare URL
        let url = URL(string: API_HOST+"signup/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // Prepare HTTP Request Parameters
        let postString = "username=\(username)&password=\(password)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                
                self.error = ErrorAlert(reason: "\(error)")
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error took place")
                self.error = ErrorAlert(reason: "Unknown error communicating with server")
                return
            }
            
            if httpResponse.statusCode == 403 {
                print("Error took place: \(httpResponse.statusCode) Account already exists")
                self.error = ErrorAlert(reason: "Username already exists")
                return
            }

            if !(200...299).contains(httpResponse.statusCode) {
                print("Error took place: \(httpResponse.statusCode)")
                self.error = ErrorAlert(reason: "\(httpResponse.statusCode)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                // set signup success message
                self.signupSuccess = true
                // take user back to login page
                self.showSignUp = false
            }
        }
        task.resume()
    }
    
}

struct SignUpForm_Previews: PreviewProvider {
    @State static var showSignUp: Bool = true
    @State static var signupSuccess: Bool = false
    
    static var previews: some View {
        SignUpForm(showSignUp: $showSignUp, signupSuccess: $signupSuccess).environmentObject(User())
    }
}
