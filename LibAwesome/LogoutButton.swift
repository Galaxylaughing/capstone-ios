//
//  LogoutButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var env: Env
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var bookList: BookList
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { self.logout() }) {
                Text("logout")
            }
            Image(systemName: "escape")
        }
    }
    
    func logout() {
             // from https://stackoverflow.com/questions/57798050/updating-published-variable-of-an-observableobject-inside-child-view
            // Clear the currentUser and booklist on the main thread
            DispatchQueue.main.async {
                let env = Env()
                self.env.user = env.user
                self.env.bookList = env.bookList
                self.env.seriesList = env.seriesList
            }
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
            .environmentObject(Env.defaultEnv)
    }
}
