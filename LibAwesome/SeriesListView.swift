//
//  SeriesListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SeriesListView: View {
    @EnvironmentObject var env: Env
    
    @State private var error: String?
    @State private var showConfirm = false
    @State private var seriesToDelete: Int = 0
    @State private var seriesNameToDelete: String = ""
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack {
                List {
                    ForEach(env.seriesList.series.sorted(by: {$0 < $1})) { series in
//                        NavigationLink(destination: SeriesDetailView().environmentObject(series)) {
                        Button(action: {
                            SeriesDetailView.series = series
                            self.env.topView = .seriesdetail
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(series.name)
                                    if series.plannedCount > 0 {
                                        Text("\(series.plannedCount) books planned")
                                            .font(.caption)
                                    }
                                }
                                Spacer()
                                ArrowRight()
                            }
                        }
                    }.onDelete(perform: self.displayConfirm)
                }
                    // from https://www.hackingwithswift.com/quick-start/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically
                    .alert(isPresented: self.$showConfirm) {
                        if self.error == nil {
                            return Alert(title: Text("Delete '\(self.seriesNameToDelete)'"),
                                         message: Text("Are you sure?"),
                                         primaryButton: .destructive(Text("Delete")) {
                                            self.swipeDeleteSeries()
                                },
                                         secondaryButton: .cancel()
                            )
                        } else {
                            return Alert(title: Text("Error"),
                                         message: Text(error!),
                                         dismissButton: Alert.Button.default(
                                            Text("OK"), action: {
                                                self.error = nil
                                                self.showConfirm = false
                                         }
                                )
                            )
                        }
                    }
            }
            AddSeriesButton()
                .padding(10)
        }
        .navigationBarTitle("Series", displayMode: .large)
    }
    
    
//    func displayConfirm(at id: Int) {
//        for book in env.bookList.books {
//            if book.id == id {
//                self.bookTitleToDelete = book.title
//            }
//        }
//        self.bookToDelete = id
//        self.showConfirm = true
//    }
    
    func displayConfirm(at offsets: IndexSet) {
        let series = env.seriesList.series.sorted(by: {$0 < $1})[offsets.first!]
        self.seriesToDelete = series.id
        self.seriesNameToDelete = series.name
        self.showConfirm = true
    }
    
    func swipeDeleteSeries() {
        self.showConfirm = false
        
        // make DELETE request
        let response = APIHelper.deleteSeries(token: self.env.user.token, seriesId: self.seriesToDelete)
        
        if response["success"] != nil {
            // remove book from environment
            if let indexToDelete = self.env.seriesList.series.firstIndex(where: {$0.id == self.seriesToDelete}) {
                let seriesList = self.env.seriesList
                seriesList.series.remove(at: indexToDelete)
                DispatchQueue.main.async {
                    self.env.seriesList = seriesList
                }
            }
        } else if response["error"] != nil {
            self.error = response["error"]!
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        } else {
            self.error = "Unknown error"
            DispatchQueue.main.async {
                self.showConfirm = true
            }
        }
    }
    
    
    
    func getSeries() {
//        let response = APIHelper.getSeries(token: self.currentUser.token)
//        print("RESPONSE", response)
    }
}

struct SeriesListView_Previews: PreviewProvider {
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 10,
        books: [])
    static var series2 = SeriesList.Series(
        id: 2,
        name: "Warrior Cats",
        plannedCount: 6,
        books: [])
    static var series3 = SeriesList.Series(
        id: 3,
        name: "Dresden Files",
        plannedCount: 0,
        books: [])
    static var seriesList = SeriesList(series: [series1, series2, series3])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: Env.defaultEnv.bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag)
    
    static var previews: some View {
        SeriesListView()
            .environmentObject(env)
    }
}
