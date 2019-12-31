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
                Button(action: { self.loginUser() }) {
                    Text("Login")
                }
//                Button(action: {self.showAlert.toggle()}) {
//                    Text("Login")
//                }.alert(isPresented: $showAlert, content: { self.alert })
            }.navigationBarTitle(Text("Login"))
        }
    }
    
//  syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    func loginUser() {
        // Prepare URL
        let url = URL(string: API_HOST+"login/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(username)&password=\(password)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place: \(error)")
                return
            }
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }
        task.resume()
    }
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
