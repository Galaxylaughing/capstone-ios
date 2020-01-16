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
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Button(action: { self.isShowingScanner.toggle() }) {
                HStack {
                    if self.showText {
                        Text("scan ISBN")
                        Text(" ")
                    }
                    Image(systemName: "barcode.viewfinder")
                }
                .foregroundColor(Color.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .padding()
                .alert(isPresented: self.$showError) {
                    return Alert(
                        title: Text("Error"),
                        message: Text(self.error),
                        dismissButton: Alert.Button.default(
                            Text("OK"),
                            action: {
                                self.error = ""
                                self.showError = false
                            }
                        )
                    )
                }
            }
            .sheet(isPresented: self.$isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.ean13, .code128],
                    simulatedData: "FakeNumber999",
                    completion: self.handleScan)
            }
        }
    }
    
    func addBookWithScannedData(isbn: String) {
        let response = ISBNHelper.addWithIsbn(isbn: isbn, env: self.env)
        
        if response["success"] != nil {
            // addWithIsbn sets self.env.book
            DispatchQueue.main.async {
                self.env.topView = .bookdetail
            }
        } else if response["error"] != nil {
            self.error = response["error"]!
            self.showError = true
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            Debug.debug(msg: "Found code: \(code)", level: .debug)
            DispatchQueue.main.async {
                self.addBookWithScannedData(isbn: code)
            }
        case .failure(let error):
            Debug.debug(msg: "\(error.localizedDescription)", level: .debug)
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.showError = true
            }
        }
        
    }
}

struct BarcodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanner()
    }
}
