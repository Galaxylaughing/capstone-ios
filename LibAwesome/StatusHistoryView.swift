//
//  StatusHistoryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct StatusHistoryView: View {
    @EnvironmentObject var env: Env
    
    @State var error: String?
    @State var onlyStatusError: String?
    @State private var showAlert: Bool = false
    @State private var bookStatusToDelete: BookStatusList.BookStatus?
    
    func getStatusHistory() {
        CallAPI.getStatusHistory(env: self.env)
        
        if Debug.debugLevel == .debug {
            for status in self.env.book.status_history {
                Debug.debug(msg: "\(status.status.getHumanReadableStatus())", level: .verbose)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("'\(self.env.book.title)'")
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            if self.env.book.status_history.count > 0 {
                List {
                    ForEach(self.env.book.status_history.sorted(by: { $0.date > $1.date }), id: \.id) { status in
                        HStack {
                            Text("\(status.status.getHumanReadableStatus())")
                            Spacer()
                            Text("\(status.date, formatter: DateHelper.getDateFormatter())")
                                .font(.caption)
                        }
                    }
                    .onDelete(perform: self.findStatusToDelete)
                }
                .alert(isPresented: self.$showAlert) {
                    if self.onlyStatusError != nil {
                        return Alert(title: Text("Cannot Delete"),
                                     message: Text(self.onlyStatusError!),
                                     dismissButton: .default(Text("OK"))
                        )
                    } else if self.error == nil {
                        return Alert(title: Text("Delete '\(self.bookStatusToDelete!.status.getHumanReadableStatus())'"),
                                     message: Text("Are you sure?"),
                                     primaryButton: .destructive(Text("Delete")) {
                                        self.swipeDeleteStatus()
                            },
                                     secondaryButton: .cancel()
                        )
                    } else {
                        return Alert(title: Text("Error"),
                                     message: Text(error!),
                                     dismissButton: Alert.Button.default(
                                        Text("OK"), action: {
                                            self.error = nil
                                            self.showAlert = false
                                     }
                            )
                        )
                    }
                }
            } else {
                Text("Could not load status history")
            }
        }
        .onAppear(perform: { self.getStatusHistory() })
    }
    
    func findStatusToDelete(at offsets: IndexSet) {
        if self.env.book.status_history.count > 1 {
            let bookStatus = self.env.book.status_history.sorted(by: { $0.date > $1.date })[offsets.first!]
            self.bookStatusToDelete = bookStatus
            self.showAlert = true
        } else {
            self.onlyStatusError = "Books must have at least one status"
            self.showAlert = true
        }
    }
    
    
    func swipeDeleteStatus() {
        self.showAlert = false
        
        // make DELETE request
        let response = APIHelper.deleteBookStatus(token: self.env.user.token, statusId: self.bookStatusToDelete!.id)
        
        if response["success"] != nil {
            // remove book status from environment
            if let indexToDelete = self.env.book.status_history.firstIndex(where: { $0.id == self.bookStatusToDelete!.id }) {
                
                // update book
                let updatedBook = self.env.book
                updatedBook.status_history.remove(at: indexToDelete)
                
                if let newCurrentStatusData = EncodingHelper.decodeDeletedStatusData(str: response["success"]!) {
                    // change current_status to be mostRecent
                    updatedBook.current_status = newCurrentStatusData.current_status
                    updatedBook.current_status_date = newCurrentStatusData.current_status_date
                }
                
                /*
                // update book's current status and current status date
                // find the most recent status
                let statusHistory = updatedBook.status_history
                var mostRecent: BookStatusList.BookStatus = statusHistory[0]
                
                // go through each status and check its date
                // if its date is more recent than mostRecent, overwrite mostRecent
                for status in statusHistory {
                    if status.date > mostRecent.date {
                        mostRecent = status
                    }
                }
                
                // change current_status to be mostRecent
                updatedBook.current_status = mostRecent.status
                updatedBook.current_status_date = mostRecent.date
                */
                
                // update booklist
                let updatedBooklist = self.env.bookList
                if let index = updatedBooklist.books.firstIndex(where: { $0.id == updatedBook.id }) {
                    updatedBooklist.books[index] = updatedBook
                }
                
                DispatchQueue.main.async {
                    self.env.book = updatedBook
                    self.env.bookList = updatedBooklist
                }
            }
        } else if response["error"] != nil {
            self.error = response["error"]!
            DispatchQueue.main.async {
                self.showAlert = true
            }
        } else {
            self.error = "Unknown error"
            DispatchQueue.main.async {
                self.showAlert = true
            }
        }
    }
    
}

struct StatusHistoryView_Previews: PreviewProvider {
    static var book = BookList.Book(
        id: 3,
        title: "The World According to Garp",
        authors: [
            "John Irving",
        ],
        current_status: Status.current,
        current_status_date: Date()
    )
    static func makeEnv() -> Env {
        let previewEnv = Env()
        previewEnv.book = book
        return previewEnv
    }
    static var env: Env = makeEnv()
    
    static var previews: some View {
        StatusHistoryView()
            .environmentObject(self.env)
    }
}
