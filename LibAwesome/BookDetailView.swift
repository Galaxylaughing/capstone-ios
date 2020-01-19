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
    
    struct DisplayHeader: View {
        @EnvironmentObject var env: Env
        fileprivate func displayHeader() -> some View {
            return Section() {
                VStack {
                    ForEach(self.env.book.findComponents(), id: \.self) { component in
                        VStack {
                            if component == self.env.book.getMainTitle() {
                                Text(self.env.book.getMainTitle())
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            } else {
                                Text(component)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    Text(self.env.book.authorNames())
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                }
                .padding()
            }
        }
        
        var body: some View {
            self.displayHeader()
        }
    }
    
    struct DisplayCurrentStatus: View {
        @EnvironmentObject var env: Env
        @State private var showMenu: Bool = false
        
        fileprivate func displayCurrentStatus() -> some View {
            return VStack {
                    Section() {
                        VStack {
                            Divider()
                            Button(action: { self.showMenu.toggle() }) {
                                HStack {
                                    Text("\(self.env.book.current_status.getHumanReadableStatus())")
                                    .padding(5)
                                    if showMenu {
                                        Image(systemName: "chevron.up")
                                    } else {
                                        Image(systemName: "chevron.down")
                                    }
                                }
                                .contextMenu {
                                    StatusButton.getStatusButtons(for: self.env.book)
                                }
                            }
                            
                            
                            if showMenu {
                                VStack {
                                    Text("\(self.env.book.current_status_date, formatter: DateHelper.getDateFormatter())")
                                    
                                    SeeStatusHistoryButton()
                                    .padding(.top)
                                }
                            }
                            
                            Divider()
                        }
                        .padding(.horizontal, 60)
                    }
                    .padding(.bottom)
                }
        }
        
        var body: some View {
            self.displayCurrentStatus()
        }
    }
    
    struct DisplaySeriesInfo: View {
        @EnvironmentObject var env: Env
        
        fileprivate func getSeriesName() -> String {
            if let series = self.env.seriesList.series.first(where: {$0.id == self.env.book.seriesId}) {
                return series.name
            }
            return "[unknown]"
        }
        
        fileprivate func displaySeriesInfo() -> AnyView {
            if self.env.book.seriesId != nil {
                return AnyView(
                    VStack {
                        Divider()
                        Section() {
                            HStack {
                                Text("# \(String(self.env.book.position))")
                                Text("|")
                                Text("\(self.getSeriesName())")
                            }
                        }
                        .padding(.vertical)
                    }
                )
            } else {
                return AnyView(EmptyView())
            }
        }
        
        var body: some View {
            self.displaySeriesInfo()
        }
    }
    
    struct DisplayTags: View {
        @EnvironmentObject var env: Env
        @State private var showTags: Bool = false
        
        fileprivate func displayTags() -> AnyView {
            return AnyView(
                Section() {
                    VStack {
                        Button(action: { self.showTags.toggle() }) {
                            HStack {
                                Text("Tags")
                                Spacer()
                                if self.showTags {
                                    Image(systemName: "chevron.up")
                                } else {
                                    Image(systemName: "chevron.down")
                                }
                            }
                        }
                        if self.showTags {
                            if self.env.book.tags.count > 0 {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        ForEach(Alphabetical(self.env.book.tags), id: \.self) { tag in
                                            TagBubble(text: EncodingHelper.decodeTagName(tagName: tag))
                                                .padding(.vertical, 4.0)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top)
                            } else {
                                Text("This book has no tags.")
                                .padding(.top)
                            }
                        }
                    }
                    .padding()
                }
            )
        }
        
        var body: some View {
            self.displayTags()
        }
    }
    
    struct DisplayISBNs: View {
        @EnvironmentObject var env: Env
        @State private var showISBNs: Bool = false
        
        fileprivate func listISBNs() -> AnyView {
            var view: AnyView
            if self.env.book.isbn10 != nil
            && self.env.book.isbn13 != nil {
                view = AnyView(
                    VStack(alignment: .leading) {
                        Text("ISBN-10: \(self.env.book.isbn10!)")
                        Text("ISBN-13: \(self.env.book.isbn13!)")
                    }
                    .padding(.top)
                )
            } else if self.env.book.isbn10 != nil {
                view = AnyView(
                    VStack(alignment: .leading) {
                        Text("ISBN-10: \(self.env.book.isbn10!)")
                    }
                    .padding(.top)
                )
            } else if self.env.book.isbn13 != nil {
                view = AnyView(
                    VStack(alignment: .leading) {
                        Text("ISBN-10: \(self.env.book.isbn13!)")
                    }
                    .padding(.top)
                )
            } else {
                view = AnyView(EmptyView())
            }
            return view
        }
        
        fileprivate func displayISBNs() -> AnyView {
            return AnyView(
                VStack {
                    Button(action: { self.showISBNs.toggle() }) {
                        HStack {
                            Text("Identifiers")
                            Spacer()
                            if self.showISBNs {
                                Image(systemName: "chevron.up")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
                    if self.showISBNs {
                        if (self.env.book.isbn10 != nil)
                        || (self.env.book.isbn13 != nil) {
                            self.listISBNs()
                        } else {
                            Text("No ISBNs available.")
                        }
                    }
                }
                .padding()
            )
        }

        var body: some View {
            self.displayISBNs()
        }
    }
    
    struct DisplayPublicationInfo: View {
        @EnvironmentObject var env: Env
        @State private var showPublicationInfo: Bool = false
        
        fileprivate func listPublicationInfo() -> AnyView {
            return AnyView(
                VStack {
                    if self.env.book.pageCount != nil {
                        Text("\(self.env.book.pageCount!) pages")
                    }
                    if self.env.book.publicationDate != nil {
                        Text("published \(self.env.book.publicationDate!)")
                    }
                    if self.env.book.publisher != nil {
                        Text("by \(self.env.book.publisher!)")
                    }
                }
                .padding(.top)
            )
        }
        
        fileprivate func displayPublicationInfo() -> AnyView {
            return AnyView(
                VStack {
                    Button(action: { self.showPublicationInfo.toggle() }) {
                        HStack {
                            Text("Publication Info")
                            Spacer()
                            if self.showPublicationInfo {
                                Image(systemName: "chevron.up")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
                    if self.showPublicationInfo {
                        if (self.env.book.pageCount != nil)
                        || (self.env.book.publicationDate != nil)
                        || (self.env.book.publisher != nil) {
                            self.listPublicationInfo()
                        } else {
                            Text("No publication information available.")
                            .padding(.top)
                        }
                    }
                }
                .padding()
            )
        }

        var body: some View {
            self.displayPublicationInfo()
        }
    }
    
    struct DisplayDescription: View {
        @EnvironmentObject var env: Env
        @State private var showDescription: Bool = false
        
        fileprivate func listDescription() -> some View {
            var view: AnyView
            if self.env.book.description != nil {
                view = AnyView(
                    Text("\(self.env.book.description!)")
                )
            } else {
                view = AnyView(
                    Text("No description available.")
                )
            }
            return view
        }
        
        fileprivate func displayDescription() -> AnyView {
            return AnyView(
                VStack {
                    Button(action: { self.showDescription.toggle() }) {
                        HStack {
                            Text("Description")
                            Spacer()
                            if self.showDescription {
                                Image(systemName: "chevron.up")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
                    if self.showDescription {
                        self.listDescription()
                        .padding()
                    }
                }
                .padding()
            )
        }

        var body: some View {
            self.displayDescription()
        }
    }
    
    // BOOK DETAIL VIEW BODY
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Group {
                        DisplayHeader()
                    }
                    
                    Group {
                        DisplayCurrentStatus()
                        DisplaySeriesInfo()
                        Divider()
                        DisplayTags()
                        Divider()
                    }

                    Group {
                        DisplayISBNs()
                        Divider()
                        DisplayPublicationInfo()
                        Divider()
                        DisplayDescription()
                    }
                }
                Spacer()
            }
        }
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
        publisher: "Harper Collins",
        publicationDate: "2011-06-28",
        isbn10: "0061991120",
        isbn13: "9780061991127",
        pageCount: 432,
        description: """
        The classic collaboration from the internationally bestselling authors Neil Gaiman and Terry Pratchett. According to The Nice and Accurate Prophecies of Agnes Nutter, Witch (the world's only completely accurate book of prophecies, written in 1655, before she exploded), the world will end on a Saturday. Next Saturday, in fact. Just before dinner. So the armies of Good and Evil are amassing, Atlantis is rising, frogs are falling, tempers are flaring. Everything appears to be going according to Divine Plan. Except a somewhat fussy angel and a fast-living demon—both of whom have lived amongst Earth's mortals since The Beginning and have grown rather fond of the lifestyle—are not actually looking forward to the coming Rapture. And someone seems to have misplaced the Antichrist.
        """,
        current_status: Status.completed,
        tags: ["fantasy", "science-fiction", "comedy", "fantasy/contemporary"]
    )
    
    static var seriesList = SeriesList(series: [series1])
    static var bookList = BookList(books: [exampleBook])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        BookDetailView()
            .environmentObject(self.env)
    }
}
