//
//  SeriesForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SeriesForm: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var series: SeriesList.Series
    @Binding var showForm: Bool
    var header: String
    var submitMessage: String
    // from https://www.hackingwithswift.com/sixty/6/4/closures-as-parameters
    var saveAction: () -> Void
    
    @State private var error: ErrorAlert?

    
    // form fields
    @State var formSeries: SeriesList.Series // name
    @State private var showCounts: Bool = false
    @State private var plannedCountIndex = 0
    let plannedCounts: [Int] = Array(1...100)

    
    // navigation bar button
    fileprivate func saveButton() -> some View {
        return Button(action: { self.saveAction() }) {
            Text("\(self.submitMessage)")
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
                            Text("Number of Books Planned: \(self.showCounts ? "\(self.plannedCountIndex + 1)" : "unknown" )")

                            if self.showCounts {
                                Button(action: { self.showCounts = false }) {
                                    Text("count is unknown")
                                }

                                Picker("Number of Books Planned:", selection: $plannedCountIndex) {
                                    ForEach(0 ..< self.plannedCounts.count) {
                                        Text("\(self.plannedCounts[$0])").tag($0)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .labelsHidden()
                            } else {
                                Button(action: { self.showCounts = true }) {
                                    Text("specify count")
                                }
                            }

                        }
                    }
                }

            }
            .navigationBarTitle("\(self.header)", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
    }
}

struct SeriesForm_Previews: PreviewProvider {
    @State static var showForm = true
    static var header = "Add Book"
    static var submitMessage = "Submit"
    static var saveAction = {
        print("saving")
    }
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 10,
        books: [])
    
    static var previews: some View {
        SeriesForm(
            showForm: $showForm,
            header: self.header,
            submitMessage: self.submitMessage,
            saveAction: self.saveAction,
            formSeries: SeriesList.Series(id: self.series1.id, name: self.series1.name, plannedCount: self.series1.plannedCount, books: self.series1.books))
    }
}
