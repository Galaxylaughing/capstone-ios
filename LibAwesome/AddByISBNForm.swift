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
    
    @Binding var showForm: Bool
    
    @State private var error: String = ""
    @State private var showAlert: Bool = false
    @State private var warningTitle: String = ""
    @State private var warningMessage: String = ""
    @State private var proceedAfterWarning: Bool = false
    
    // form fields
    @State private var isbn: String = ""
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.addBookWithIsbn(isbn: self.isbn) }) {
            Text("Add Book")
        }
        // disable if no isbn
        .disabled(self.isbn == "")
        .alert(isPresented: self.$showAlert) {
            if self.warningMessage != "" {
                return Alert(
                    title: Text(self.warningTitle),
                    message: Text(self.warningMessage),
                    primaryButton: .destructive(Text("Add Book")) {
                        self.warningTitle = ""
                        self.warningMessage = ""
                        self.proceedAfterWarning = true
                        self.showAlert = false
                        self.addBookWithIsbn(isbn: self.isbn)
                    },
                    secondaryButton: .cancel() {
                        self.isbn = ""
                        self.showForm = false
                    }
                )
                
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text(self.error),
                    dismissButton: Alert.Button.default(
                        Text("OK"),
                        action: {
                            self.error = ""
                            self.showAlert = false
                        }
                    )
                )
            }
        }
         
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
                                .keyboardType(.numberPad)
                        }
                    }
                }
            }
            .navigationBarTitle("Add With ISBN", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    // SUBMIT FORM
    func addBookWithIsbn(isbn: String) {
        var isbnIsPresent = false
        
        if !self.proceedAfterWarning {
            isbnIsPresent = BookHelper.isPresentInList(isbn: isbn, in: self.env.bookList.books)
        }
        
        if isbnIsPresent {
            self.warningTitle = "This ISBN is already present in your library."
            self.warningMessage = "Are you sure you want to add it?"
            self.showAlert = true
        }
        
        if (!isbnIsPresent) || (isbnIsPresent && self.proceedAfterWarning) {
            let response = ISBNHelper.addWithIsbn(isbn: self.isbn, env: self.env)
            
            if response["success"] != nil {
                // addWithIsbn sets self.env.book
                DispatchQueue.main.async {
                    self.env.topView = .bookdetail
                }
                self.showForm = false
            } else if response["error"] != nil {
                self.error = response["error"]!
                self.showAlert = true
            }
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
