//
//  LoginForm.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LoginForm: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var error: ErrorAlert?
    
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
                }.alert(item: $error, content: { error in
                    alert(reason: error.reason)
                })
            }.navigationBarTitle(Text("Login"))
        }
    }
    
    // alert structure from https://goshdarnswiftui.com/
    func alert(reason: String) -> Alert {
        Alert(title: Text("Error"),
                message: Text(reason),
                dismissButton: .default(Text("OK"))
        )
    }
    
    func getToken(json: Data) -> String? {
        // create a token variable
        var token: String?
        
        // create a decoder
        let decoder = JSONDecoder()
        
        // create an object to match the JSON structure
        struct TokenService: Decodable {
            let token: String
        }
        
        // decode the JSON into the object
        if let tokenService = try? decoder.decode(TokenService.self, from: json) {
            // map object-ified JSON to goal object
            token = tokenService.token
        }
        
        return token
    }
    
    //  syntax from http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
    func loginUser() {
        // Prepare URL
        let url = URL(string: API_HOST+"auth-token/")
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
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                guard let userToken = self.getToken(json: data) else { fatalError() } //TODO: don't throw fatal error
                User.current = User(username: self.username, token: userToken)
                
                //TODO: redirect to ContentView
            }
        }
        task.resume()
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}

// when someone clicks login,
// the app needs to make a POST request to the API's login url
// providing a username and password

// if correct, a JSON of id and username will be returned.
// otherwise, an error message and non-200 status code