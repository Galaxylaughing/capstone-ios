//
//  CurrentReadsList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct CurrentReadsList: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        VStack {
            List {
                ForEach(Env.getCurrentReads(from: self.env.bookList).books, id: \.id) { book in
                    
                    Button(action: {
                        self.env.book = book
                        self.env.topView = .bookdetail
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                Text(book.authorNames())
                                    .font(.caption)
                                Text("started \(book.current_status_date, formatter: DateHelper.getDateFormatter())")
                                    .italic()
                                    .font(.caption)
                            }
                            Spacer()
                            ArrowRight()
                        }
                        .contextMenu {
                            StatusButton.getStatusButtons(for: book)
                        }
                    }
                    
                }
            }
        }
    }
}

struct CurrentReadsList_Previews: PreviewProvider {
    static var bookList = BookList(books: [
        BookList.Book(
            id: 1,
            title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
            authors: [
                "Neil Gaiman",
                "Terry Pratchett",
            ],
            current_status: Status.current,
            current_status_date: Date()
        ),
        BookList.Book(
            id: 2,
            title: "Spinning Silver",
            authors: [
                "Naomi Novik",
            ],
            current_status: Status.current,
            current_status_date: Date()
        ),
        BookList.Book(
            id: 3,
            title: "The World According to Garp",
            authors: [
                "John Irving",
            ],
            current_status: Status.current,
            current_status_date: Date()
        ),
        BookList.Book(
            id: 4,
            title: "A Natural History of Dragons",
            authors: [
                "Marie Brennan",
            ],
            current_status: Status.current,
            current_status_date: Date()
        ),
    ])
    static func makeEnv() -> Env {
        let previewEnv = Env()
        previewEnv.bookList = bookList
        return previewEnv
    }
    static var env = makeEnv()
    
    static var previews: some View {
        CurrentReadsList()
            .environmentObject(self.env)
    }
}
