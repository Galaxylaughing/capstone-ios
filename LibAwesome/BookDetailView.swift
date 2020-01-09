//
//  BookDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/3/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var env: Env
    @EnvironmentObject var book: BookList.Book
    
    var body: some View {
        VStack {
            VStack { // title and author
                ForEach(book.findComponents(), id: \.self) { component in
                    VStack {
                        if component == self.book.getMainTitle() {
                            Text(self.book.getMainTitle())
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(component)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                Text(book.authorNames())
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading) {
                    Section() { // series, position in series
                        if book.seriesId != nil {
                            Text("# \(String(book.position)) | \(self.getSeriesName())")
                        }
                    }
                    .padding([.top, .leading])
                    
                    Section() { // tags
                        HStack {
                            VStack(alignment: .leading) {
                                ForEach(Alphabetical(self.book.tags), id: \.self) { tag in
                                    TagBubble(text: tag)
                                        .padding(.vertical, 4)
                                }
                            }
                            .padding(.leading)
                            Spacer()
                        }
                    }
                    .padding(.top)
                }
            }
            Spacer()
        }
        .navigationBarTitle(Text(book.getMainTitle()), displayMode: .inline)
        .navigationBarItems(trailing: EditBookButton().environmentObject(self.book))
    }
    
    func getSeriesName() -> String {
        if let series = self.env.seriesList.series.first(where: {$0.id == book.seriesId}) {
            return series.name
        }
        return "[unknown]"
    }
    
}

struct BookDetailView_Previews: PreviewProvider {
    static var series1 = SeriesList.Series(
        id: 1,
        name: "Animorphs",
        plannedCount: 10,
        books: [1])
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
        ],
        position: 1,
        seriesId: 1,
        tags: ["non-fiction", "fantasy", "science-fiction", "mystery", "fantasy/contemporary"])
    
    static var seriesList = SeriesList(series: [series1])
    static var bookList = BookList(books: [exampleBook])
    static var env = Env(user: Env.defaultEnv.user, bookList: bookList, seriesList: seriesList, tagList: Env.defaultEnv.tagList, tag: Env.defaultEnv.tag
)
    
    static var previews: some View {
        BookDetailView()
            .environmentObject(self.env)
            .environmentObject(self.exampleBook)
    }
}
