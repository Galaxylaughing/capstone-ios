//
//  AddStatusForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddStatusForm: View {
    @EnvironmentObject var env: Env
    @Binding var showForm: Bool
    @State private var error: ErrorAlert?
    
    var bookToUpdate: BookList.Book
    var newStatus: Status
    @State private var date: Date = Date()
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.addStatus() }) {
            Text("Confirm")
        }
        .alert(item: $error, content: { error in
            AlertHelper.alert(reason: error.reason)
        })
    }
    fileprivate func cancelButton() -> some View {
        return Button(action: { self.showForm = false }) {
            Text("Cancel")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Text("Update Status To:")
                            .padding(.bottom)
                        Text("\(self.newStatus.getHumanReadableStatus())")
                            .font(.title)
                        Divider()
                    }
                    .padding(.horizontal, 50)
                    
                    VStack {
                        HStack {
                            Text("Previous Status:")
                            Text(self.bookToUpdate.current_status.getHumanReadableStatus())
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal, 50)
                }
                .padding(.bottom, 40)
                
                VStack {
                    HStack {
                        Text("Status Date: ")
                        Text("\(date, formatter: DateHelper.getDateFormatter())")
                    }
                    
                    DatePicker(selection: $date,
                               in: ...Date(),
                               displayedComponents: .date) {
                        Text("Select a date")
                    }
                    .labelsHidden()
                }
                .padding(.top)
            }
            .navigationBarTitle("Update Status", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    func addStatus() {
        // date
        let formatter = ISO8601DateFormatter()
        let isoDateString = formatter.string(from: self.date)
        Debug.debug(msg: "\(isoDateString)", level: .debug)
        
        // POST a new status to API
        let response = APIHelper.postStatus(
            token: self.env.user.token,
            bookId: self.bookToUpdate.id,
            statusCode: self.newStatus.rawValue,
            isoDate: isoDateString
        )
        
        let oldStatus = self.bookToUpdate.current_status
        if response["success"] != nil {
            print("successfully posted new status")
            
            // find book in environment booklist and change it's status
            let tempBookList = self.env.bookList
            if let index = tempBookList.books.firstIndex(where: {$0.id == self.bookToUpdate.id}) {
                tempBookList.books[index].current_status = newStatus
            }
            // update environment currently reading count
            var currentReadsCount = self.env.currentReadsCount
            if newStatus == Status.current
            && oldStatus != Status.current {
                currentReadsCount += 1
            } else if oldStatus == Status.current
            && newStatus != Status.current {
                currentReadsCount -= 1
            }
            
            DispatchQueue.main.async {
                self.env.bookList = tempBookList
                self.env.currentReadsCount = currentReadsCount
            }
            // dismiss sheet
            self.showForm = false
        } else if response["error"] != nil {
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "unknown error")
        }
        
    }
}

struct AddStatusForm_Previews: PreviewProvider {
    @State static var showForm: Bool = true
    static var env = Env()
    static var bookToUpdate = BookList.Book()
    static var newStatus = Status.current
    
    static var previews: some View {
        AddStatusForm(
            showForm: self.$showForm,
            bookToUpdate: self.bookToUpdate,
            newStatus: self.newStatus
        )
        .environmentObject(self.env)
    }
}
