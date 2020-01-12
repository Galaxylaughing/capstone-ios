//
//  DeleteSeriesButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct DeleteSeriesButton: View {
    @EnvironmentObject var env: Env
    
    @State private var error: String?
    @State private var showConfirm = false
    
    var body: some View {
        Button(action: { self.displayConfirm() }) {
            DeleteIcon()
        }
        .alert(isPresented: self.$showConfirm) {
            if self.error == nil {
                return Alert(title: Text("Delete '\(SeriesDetailView.series.name)'"),
                             message: Text("Are you sure?"),
                             primaryButton: .destructive(Text("Delete")) {
                                self.deleteSeries()
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
    
    
    func displayConfirm() {
        self.showConfirm = true
    }
    
    func deleteSeries() {
        self.showConfirm = false
        // make DELETE request
        let response = APIHelper.deleteSeries(token: self.env.user.token, seriesId: SeriesDetailView.series.id)
        if response["success"] != nil {
            // remove series from environment
            if let indexToDelete = self.env.seriesList.series.firstIndex(where: {$0.id == SeriesDetailView.series.id}) {
                let seriesToDelete = self.env.seriesList.series[indexToDelete]
                // find all books in series and set their seriesIds and positions to nil/0
                let bookList = self.env.bookList
                for bookId in seriesToDelete.books {
                    if let book = bookList.books.first(where: {$0.id == bookId}) {
                        book.position = 0
                        book.seriesId = nil
                    }
                }
                let seriesList = self.env.seriesList
                seriesList.series.remove(at: indexToDelete)
                DispatchQueue.main.async {
                    self.env.seriesList = seriesList
                    self.env.bookList = bookList
                    // return the view to previous position
                    NavView.goBack(env: self.env)
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
}

struct DeleteSeriesButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSeriesButton()
    }
}
