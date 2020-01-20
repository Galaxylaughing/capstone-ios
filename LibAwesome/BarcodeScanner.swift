//
//  BarcodeScanner.swift
//  LibAwesome
//
//  Created by Sabrina on 1/15/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI
// tutorial from https://www.hackingwithswift.com/books/ios-swiftui/scanning-qr-codes-with-swiftui
// dependency from https://github.com/twostraws/CodeScanner
import CodeScanner

//CodeScannerView has three parameters:
//  1. an array of the types to scan for,
//  2. some test data to send back when running in the simulator,
//  3. a closure that will be called when a result is ready.
//    This closure must accept a Result<String, ScanError>,
//      where the string is the code that was found on success and
//      ScanError will be either badInput (if the camera cannot be accessed)
//      or badOutput (if the camera is not capable of detecting codes.)

struct BarcodeScanner: View {
    @EnvironmentObject var env: Env
    var showText: Bool = true
    @State private var isShowingScanner = false
    
    @State private var result: String = ""
    @State private var error: String = ""
    @State private var showAlert: Bool = false
    
    @State private var warningTitle: String = ""
    @State private var warningMessage: String = ""
    @State private var proceedAfterWarning: Bool = false
    
    @State private var isbn: String = ""
    
    var body: some View {
        VStack {
            Button(action: { self.isShowingScanner.toggle() }) {
                HStack {
                    if self.showText {
                        Text("scan ISBN")
                        Text(" ")
                    }
                    Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .frame(width: 20, height: 20)
                }
                .foregroundColor(Color.white)
                .padding()
                .background(
                    Circle()
                )
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
                                self.addBookWithScannedData(isbn: self.isbn)
                            },
                            secondaryButton: .cancel()
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
            .sheet(isPresented: self.$isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.ean8, .ean13, .upce, .code39, .code39Mod43, .code93, .code128, .interleaved2of5, .itf14],
                    simulatedData: "FakeNumber999",
                    completion: self.handleScan
                )
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    func addBookWithScannedData(isbn: String) {
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
            let response = ISBNHelper.addWithIsbn(isbn: isbn, env: self.env)
            
            if response["success"] != nil {
                // addWithIsbn sets self.env.book
                DispatchQueue.main.async {
                    self.env.topView = .bookdetail
                }
            } else if response["error"] != nil {
                self.error = response["error"]!
                self.showAlert = true
            }
        }
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            var isbnCode = code
            Debug.debug(msg: "Found code: \(isbnCode)", level: .verbose)
            
            /* from: https://bisg.org/page/BarcodingGuidelines ->
             "The number set zero [0] was assigned to the UPC. Thus the 12-digit UPC in the US and Canada is a subset of, and fully compatible with, the 13-digit EAN by the addition of the zero prefix."
             */
            if code.count == 12 {
                isbnCode = "0" + code
                Debug.debug(msg: "Created code: \(isbnCode)", level: .verbose)
            }
            
            DispatchQueue.main.async {
                self.isbn = isbnCode
                self.addBookWithScannedData(isbn: isbnCode)
            }
        case .failure(let error):
            Debug.debug(msg: "\(error.localizedDescription)", level: .verbose)
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.showAlert = true
            }
        }
        
    }
}

struct BarcodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanner(showText: false)
    }
}
