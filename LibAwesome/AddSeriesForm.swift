//
//  AddSeriesForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddSeriesForm: View {
    @EnvironmentObject var env: Env
    
    @State private var error: ErrorAlert?
    @Binding var showForm: Bool
    
    // form fields
    @State private var name: String = ""
    @State private var showCounts: Bool = false
    @State private var plannedCountIndex = 0
    let plannedCounts: [Int] = Array(1...100)
    
    // form field validation
    @State private var showNameValidation: Bool = false
    @State private var showCountValidation: Bool = false
    
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.createSeries() }) {
            Text("Add Series")
        }
            // disable if no name
            .disabled(self.name == "")
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
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Name *")
                                Spacer()
                                if self.showNameValidation {
                                    Text("name is required")
                                        .foregroundColor(Color.red)
                                }
                            }
                            TextField("series name", text: $name)
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Toggle(isOn: $showCounts) {
                                Text("Assign Number of Books Planned")
                            }
                            .toggleStyle(DefaultToggleStyle())
                            
                            if self.showCounts {
                                Text("").padding(1) // if you delete this, you won't be able to toggle the toggle off
                                VStack {
                                    Picker("Number of Books Planned:", selection: $plannedCountIndex) {
                                        ForEach(0 ..< self.plannedCounts.count) {
                                            Text("\(self.plannedCounts[$0])").tag($0)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .labelsHidden()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("Add Series", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    
    // name validation
    func checkSeriesName(name: String) {
        if name.count > 0 {
            self.showNameValidation = false
        } else {
            self.showNameValidation = true
        }
    }
    
    // SUBMIT FORM
    func createSeries() {
        var plannedCount: Int = 0
        if self.showCounts {
            plannedCount = self.plannedCounts[self.plannedCountIndex]
        }
        
        let response = APIHelper.postSeries(token: self.env.user.token, name: self.name, plannedCount: plannedCount, books: [])
        
        if response["success"] != nil {
            // add new book to environment BookList
            if let newSeries = EncodingHelper.makeSeries(data: response["success"]!) {
                let seriesList = self.env.seriesList
                seriesList.series.append(newSeries)
                DispatchQueue.main.async {
                    self.env.seriesList = seriesList
                }
            }
            // should dismiss sheet if success
            self.showForm = false
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
        
    }
}

struct AddSeriesForm_Previews: PreviewProvider {
    @State static var showForm = true
    
    static var previews: some View {
        AddSeriesForm(showForm: $showForm)
    }
}
