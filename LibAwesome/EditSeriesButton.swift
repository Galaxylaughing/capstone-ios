//
//  EditSeriesButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditSeriesButton: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var series: SeriesList.Series
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            EditIcon()
        }.sheet(isPresented: $showForm) {            
            EditSeriesForm(showForm: self.$showForm, formSeries: SeriesList.Series(id: self.series.id, name: self.series.name, plannedCount: self.series.plannedCount, books: self.series.books), showCounts: (self.series.plannedCount > 0))
                .environmentObject(self.env)
                .environmentObject(self.series)
        }
    }
}

struct EditSeriesButton_Previews: PreviewProvider {
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 10,
        books: [])
    
    static var previews: some View {
        EditSeriesButton()
            .environmentObject(self.series1)
    }
}
