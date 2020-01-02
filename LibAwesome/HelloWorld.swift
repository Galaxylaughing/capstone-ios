//
//  HelloWorld.swift
//  LibAwesome
//
//  Created by Sabrina on 1/1/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct HelloWorld: View {
    @EnvironmentObject var currentUser: User
    
    var body: some View {
        Button(action: { self.getHello() }) {
            Text("Hello World!")
        }
    }
    
    func getHello() {
        // Prepare URL
        let url = URL(string: API_HOST+"helloworld/")
        guard let requestUrl = url else { fatalError() } // unwraps `URL?` object

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        //Prepare HTTP Request Header
        let value = "Token \(self.currentUser.token ?? "")"
        request.setValue(value, forHTTPHeaderField: "Authorization")
         
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

struct HelloWorld_Previews: PreviewProvider {
    static var previews: some View {
        HelloWorld().environmentObject(User())
    }
}
