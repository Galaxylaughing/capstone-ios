//
//  EditBookButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditBookButton: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var book: BookList.Book
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            EditIcon()
        }.sheet(isPresented: $showForm) {
            EditBookForm(showForm: self.$showForm,
                         bookToEdit: BookList.Book(id: self.book.id, title: self.book.title, authors: self.book.authors),
                         assignSeries: (self.book.seriesId != nil),
                         seriesIndex: self.getSeriesIndex(),
                         seriesPositionIndex: self.book.position - 1)
                .environmentObject(self.env)
                .environmentObject(self.book)
        }
    }
    
    func getSeriesIndex() -> Int {
        var seriesIndex = 0
        let seriesList = self.env.seriesList.series
        if let index = seriesList.firstIndex(where: {$0.id == self.book.seriesId}) {
            seriesIndex = index
        }
        return seriesIndex
    }
}

struct EditBookButton_Previews: PreviewProvider {
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    
    static var previews: some View {
        EditBookButton()
            .environmentObject(self.exampleBook)
    }
}
