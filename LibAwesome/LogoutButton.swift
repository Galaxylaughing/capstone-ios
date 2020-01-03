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
    }
    
    func logout() {
        let response = APIHelper.logout(token: self.currentUser.token)
        
        print("caller sees: \(response)")
        
        if let _ = response["success"] {
            // from https://stackoverflow.com/questions/57798050/updating-published-variable-of-an-observableobject-inside-child-view
            // Clear the currentUser on the main thread
            DispatchQueue.main.async {
                self.currentUser.username = nil
                self.currentUser.token = nil
            }
        } else if let errorData = response["error"] {
            print(errorData)
        } else {
            print("other unknown error")
        }
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton().environmentObject(User())
    }
}
