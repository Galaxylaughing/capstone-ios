//
//  EditBookButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/5/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

class FormBook {
    var id: Int
    var title: String
    var authors: [String]
    var position: Int
    var seriesId: Int?
    var publisher: String
    var publicationDate: String
    var isbn10: String
    var isbn13: String
    var pageCount: String
    var description: String
    var tags: [String]
    
    init(book: BookList.Book) {
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.position = book.position
        self.seriesId = book.seriesId
        self.publisher = book.publisher ?? ""
        self.publicationDate = book.publicationDate ?? ""
        self.isbn10 = book.isbn10 ?? ""
        self.isbn13 = book.isbn13 ?? ""
        let pageCount: Int = book.pageCount ?? 0
        let stringified: String = (pageCount == 0 ? "" : String(pageCount))
        self.pageCount = stringified
        self.description = book.description ?? ""
        self.tags = book.tags
    }
    
    init(book: FormBook) {
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.position = book.position
        self.seriesId = book.seriesId
        self.publisher = book.publisher
        self.publicationDate = book.publicationDate
        self.isbn10 = book.isbn10
        self.isbn13 = book.isbn13
        self.pageCount = String(book.pageCount)
        self.description = book.description
        self.tags = book.tags
    }
}

struct EditBookButton: View {
    @EnvironmentObject var env: Env
    @State var showForm: Bool = false
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            EditIcon()
        }.sheet(isPresented: $showForm) {
            EditBookForm(showForm: self.$showForm,
                         bookToEdit: FormBook(book: self.env.book),
                         assignSeries: (self.env.book.seriesId != nil),
                         seriesIndex: self.getSeriesIndex(),
                         seriesPositionIndex: (self.env.book.position - 1))
                .environmentObject(self.env)
        }
    }
    
    func getSeriesIndex() -> Int {
        var seriesIndex = 0
        let seriesList = self.env.seriesList.series
        if let index = seriesList.firstIndex(where: {$0.id == self.env.book.seriesId}) {
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
    }
}
