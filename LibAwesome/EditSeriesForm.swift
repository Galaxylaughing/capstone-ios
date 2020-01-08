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
    @State var showCounts: Bool
    
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
                            }.toggleStyle(DefaultToggleStyle())
                            if self.showCounts {
                                Picker("Number of Books Planned:", selection: self.$formSeries.plannedCount) {
                                    Group {
                                        Text("1").tag(1)
                                        Text("2").tag(2)
                                        Text("3").tag(3)
                                        Text("4").tag(4)
                                        Text("5").tag(5)
                                        Text("6").tag(6)
                                        Text("7").tag(7)
                                        Text("8").tag(8)
                                        Text("9").tag(9)
                                        Text("10").tag(10)
                                    }
                                    Group {
                                        Text("11").tag(11)
                                        Text("12").tag(12)
                                        Text("13").tag(13)
                                        Text("14").tag(14)
                                        Text("15").tag(15)
                                        Text("16").tag(16)
                                        Text("17").tag(17)
                                        Text("18").tag(18)
                                        Text("19").tag(19)
                                        Text("20").tag(20)
                                    }
                                    Group {
                                        Text("21").tag(21)
                                        Text("22").tag(22)
                                        Text("23").tag(23)
                                        Text("24").tag(24)
                                        Text("25").tag(25)
                                        Text("26").tag(26)
                                        Text("27").tag(27)
                                        Text("28").tag(28)
                                        Text("29").tag(29)
                                        Text("30").tag(30)
                                    }
                                    Group {
                                        Text("31").tag(31)
                                        Text("32").tag(32)
                                        Text("33").tag(33)
                                        Text("34").tag(34)
                                        Text("35").tag(35)
                                        Text("36").tag(36)
                                        Text("37").tag(37)
                                        Text("38").tag(38)
                                        Text("39").tag(39)
                                        Text("40").tag(40)
                                    }
                                    Group {
                                        Text("41").tag(41)
                                        Text("42").tag(42)
                                        Text("43").tag(43)
                                        Text("44").tag(44)
                                        Text("45").tag(45)
                                        Text("46").tag(46)
                                        Text("47").tag(47)
                                        Text("48").tag(48)
                                        Text("49").tag(49)
                                        Text("50").tag(50)
                                    }
                                    Group {
                                        Text("51").tag(51)
                                        Text("52").tag(52)
                                        Text("53").tag(53)
                                        Text("54").tag(54)
                                        Text("55").tag(55)
                                        Text("56").tag(56)
                                        Text("57").tag(57)
                                        Text("58").tag(58)
                                        Text("59").tag(59)
                                        Text("60").tag(60)
                                    }
                                    Group {
                                        Text("61").tag(61)
                                        Text("62").tag(62)
                                        Text("63").tag(63)
                                        Text("64").tag(64)
                                        Text("65").tag(65)
                                        Text("66").tag(66)
                                        Text("67").tag(67)
                                        Text("68").tag(68)
                                        Text("69").tag(69)
                                        Text("70").tag(70)
                                    }
                                    Group {
                                        Text("71").tag(71)
                                        Text("72").tag(72)
                                        Text("73").tag(73)
                                        Text("74").tag(74)
                                        Text("75").tag(75)
                                        Text("76").tag(76)
                                        Text("77").tag(77)
                                        Text("78").tag(78)
                                        Text("79").tag(79)
                                        Text("80").tag(80)
                                    }
                                    Group {
                                        Text("81").tag(81)
                                        Text("82").tag(82)
                                        Text("83").tag(83)
                                        Text("84").tag(84)
                                        Text("85").tag(85)
                                        Text("86").tag(86)
                                        Text("87").tag(87)
                                        Text("88").tag(88)
                                        Text("89").tag(89)
                                        Text("90").tag(90)
                                    }
                                    Group {
                                        Text("91").tag(91)
                                        Text("92").tag(92)
                                        Text("93").tag(93)
                                        Text("94").tag(94)
                                        Text("95").tag(95)
                                        Text("96").tag(96)
                                        Text("97").tag(97)
                                        Text("98").tag(98)
                                        Text("99").tag(99)
                                        Text("100").tag(100)
                                    }
                                // This code throws an error when the toggle hides the picker, so the above hard-coded list is used instead
//                                    ForEach(1 ... 100, id: \.self) {
//                                        Text("\($0)").tag($0)
//                                    }.id(0)
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
            plannedCount = self.formSeries.plannedCount
        }
        
        let response = APIHelper.putSeries(token: self.env.user.token, seriesId: self.series.id, name: self.formSeries.name, plannedCount: plannedCount, books: self.formSeries.books)
        
        if response["success"] != nil {
            // add new book to environment BookList
            if let newSeries = EncodingHelper.makeSeries(data: response["success"]!) {
                let seriesList = self.env.seriesList
                if let index = seriesList.series.firstIndex(where: {$0.id == newSeries.id}) {
                    seriesList.series[index] = newSeries
                }
                DispatchQueue.main.async {
                    self.env.seriesList = seriesList
                }
                self.series.name = newSeries.name
                self.series.plannedCount = newSeries.plannedCount
                self.series.books = newSeries.books
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
            formSeries: SeriesList.Series(id: self.series1.id, name: self.series1.name, plannedCount: self.series1.plannedCount, books: self.series1.books), showCounts: true)
    }
}
