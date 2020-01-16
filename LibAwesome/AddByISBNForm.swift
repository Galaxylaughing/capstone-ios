//
//  AddByISBNForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/13/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddByISBNForm: View {
    @EnvironmentObject var env: Env
    
    @State private var error: ErrorAlert?
    @Binding var showForm: Bool
    
    // form fields
    @State private var isbn: String = ""
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.addBook() }) {
            Text("Add Book")
        }
        // disable if no isbn
        .disabled(self.isbn == "")
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
        NavigationView() {
            VStack {
                Form {
                    Section(
                    header: Text("ISBN"),
                    footer: HStack { Spacer(); Text("accepts ISBN-10 or ISBN-13"); Spacer() }
                    ) {
                        VStack(alignment: .leading) {
                            TextField("isbn", text: $isbn)
                        }
                    }
                }
            }
            .navigationBarTitle("Add With ISBN", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    // SUBMIT FORM
    func addBook() {
        let response = ISBNHelper.addWithIsbn(isbn: self.isbn, env: self.env)
        
        if response["success"] != nil {
            DispatchQueue.main.async {
                self.env.topView = .bookdetail
            }
            self.showForm = false
        } else if response["error"] != nil {
            self.error = ErrorAlert(reason: response["error"]!)
        }
    }
}

struct AddByISBNForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var env = Env()
    
    static var previews: some View {
        AddByISBNForm(showForm: $showForm)
            .environmentObject(self.env)
    }
}
