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
//    @EnvironmentObject var currentUser: User
//    @EnvironmentObject var bookList: BookList
//    @EnvironmentObject var seriesList: SeriesList
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack {
                List {
                    ForEach(env.seriesList.series.sorted(by: {$0 < $1})) { series in
//                        NavigationLink(destination: BookDetailView().environmentObject(book)) {
                            VStack(alignment: .leading) {
                                Text(series.name)
                                if series.plannedCount > 0 {
                                    Text("\(series.plannedCount) books planned")
                                        .font(.caption)
                                }
                            }
//                        }
                    }/*.onDelete(perform: self.displayConfirm)*/
                }
                    // from https://www.hackingwithswift.com/quick-start/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically
                    /*.alert(isPresented: self.$showConfirm) {
                        if self.error == nil {
                            return Alert(title: Text("Delete '\(self.bookTitleToDelete)'"),
                                         message: Text("Are you sure?"),
                                         primaryButton: .destructive(Text("Delete")) {
                                            self.swipeDeleteBook()
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
                    }*/
            }
            AddSeriesButton()
//            .contextMenu {
//                AddButton()
//                AddSeriesButton()
//            }
            .padding(10)
        }
        .navigationBarTitle("Series", displayMode: .large)
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
    static var env = Env(user: Env.defaultEnv.user, bookList: Env.defaultEnv.bookList, seriesList: seriesList)
    
    static var previews: some View {
        SeriesListView()
            .environmentObject(env)
    }
}
