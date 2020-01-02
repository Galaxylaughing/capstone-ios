//
//  LogoutButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var currentUser: User
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { self.logout() }) {
                Text("logout")
            }
            Image("first")
        }
        .padding()
    }
    
    func logout() {
        // Prepare URL
        let url = URL(string: API_HOST+"logout/")
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
         
                 // from https://stackoverflow.com/questions/57798050/updating-published-variable-of-an-observableobject-inside-child-view
                 // Clear the currentUser on the main thread
                 DispatchQueue.main.async {
                     self.currentUser.username = nil
                     self.currentUser.token = nil
                 }
            }
        }
        task.resume()
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton().environmentObject(User())
    }
}
