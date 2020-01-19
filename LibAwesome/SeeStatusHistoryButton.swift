//
//  SeeStatusHistoryButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SeeStatusHistoryButton: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        // you can only get here from the book detail page,
        // which has the env.book set already
        // so you don't have to set the env.book here
        Button(action: { self.env.topView = .statushistory }) {
            HStack {
                Text("see status history")
                    .font(.caption)
            }
        }
    }
}

struct SeeStatusHistoryButton_Previews: PreviewProvider {
    static var env = Env()
    
    static var previews: some View {
        SeeStatusHistoryButton()
            .environmentObject(self.env)
    }
}
