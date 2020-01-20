//
//  StatusButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct StatusButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    let status: Status
    var bookToUpdate: BookList.Book
    
    static func getStatusButtons(for book: BookList.Book) -> VStack<TupleView<(StatusButton, StatusButton, StatusButton, StatusButton, StatusButton)>> {
        return VStack {
            StatusButton(status: Status.wanttoread, bookToUpdate: book)
            StatusButton(status: Status.current, bookToUpdate: book)
            StatusButton(status: Status.completed, bookToUpdate: book)
            StatusButton(status: Status.paused, bookToUpdate: book)
            StatusButton(status: Status.discarded, bookToUpdate: book)
        }
    }
    
    fileprivate func isCurrent() -> Bool {
        return self.bookToUpdate.current_status == self.status
    }
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            HStack {
                Text(self.status.getHumanReadableStatus())
                if self.isCurrent() {
                    Image(systemName: "checkmark.circle")
                }
            }
        }.sheet(isPresented: $showForm) {
            AddStatusForm(
                showForm: self.$showForm,
                bookToUpdate: self.bookToUpdate,
                newStatus: self.status
            )
            .environmentObject(self.env)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct StatusButton_Previews: PreviewProvider {
    static var bookToUpdate = BookList.Book()
    
    static var previews: some View {
        StatusButton(
            status: Status.wanttoread,
            bookToUpdate: self.bookToUpdate
        )
    }
}
