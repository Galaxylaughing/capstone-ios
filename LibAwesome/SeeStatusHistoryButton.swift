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
    @State var showHistorySheet: Bool = false
    
    var body: some View {
        // you can only get here from the book detail page,
        // which has the env.book set already
        // so you don't have to set the env.book here
        Button(action: { self.getStatusHistory(); self.showHistorySheet.toggle()/*self.env.topView = .statushistory*/ }) {
            HStack {
                Text("see status history")
                    .font(.caption)
            }
        }.sheet(isPresented: self.$showHistorySheet) {
            StatusHistoryView()
                .environmentObject(self.env)
        }
    }
    
    func getStatusHistory() {
        CallAPI.getStatusHistory(env: self.env)
        
        if Debug.debugLevel == .debug {
            for status in self.env.book.status_history {
                Debug.debug(msg: "\(status.status.getHumanReadableStatus())", level: .verbose)
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
