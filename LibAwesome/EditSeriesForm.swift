//
//  EditSeriesForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditSeriesForm: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var series: SeriesList.Series
    @Binding var showForm: Bool
    
    @State private var error: ErrorAlert?

    // form fields
    @State var formSeries: SeriesList.Series // name
    @State var showCounts: Bool = false
//    @State var plannedCountIndex = 0
//    let plannedCounts: [Int] = Array(1...100)
    
    
    // navigation bar button
    fileprivate func saveButton() -> some View {
        return Button(action: { self.updateSeries() }) {
            Text("Save")
        }
            // disable if no name
            .disabled(self.formSeries.name == "")
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
                            }
                            TextField("series name", text: $formSeries.name)
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Toggle(isOn: $showCounts) {
                                Text("Assign Number of Books Planned")
                            }
                            if self.showCounts {
                                Picker("Number of Books Planned:", selection: self.$formSeries.plannedCount) {
                                    ForEach(1 ... 100, id: \.self) {
                                        Text("\($0)").tag($0)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .labelsHidden()
                            }
                        }
                    }
                }

            }
            .navigationBarTitle("Edit Series", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
    
    func updateSeries() {
        var plannedCount: Int = 0
        if self.showCounts {
            plannedCount = self.formSeries.plannedCount//self.plannedCounts[self.formSeries.plannedCount]
        }
        
        let response = APIHelper.postSeries(token: self.env.user.token, name: self.formSeries.name, plannedCount: plannedCount, books: self.formSeries.books)
        
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

struct EditSeriesForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 2,
        books: [])
    
    static var previews: some View {
        EditSeriesForm(
            showForm: $showForm,
            formSeries: SeriesList.Series(id: self.series1.id, name: self.series1.name, plannedCount: self.series1.plannedCount, books: self.series1.books))
    }
}
