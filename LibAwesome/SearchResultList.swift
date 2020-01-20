//
//  SearchResultList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SearchResultRow: View {
    var book: BookList.Book
    @State private var showResultDetails: Bool = false
    
    fileprivate func displayResultData() -> some View {
        return VStack(alignment: .center) {
                    VStack {
                        Divider()
                        Text("Publisher")
                        Text(book.publisher ?? "not provided")
                    }
                    VStack {
                        Divider()
                        Text("Publication Date")
                        Text(book.publicationDate ?? "not provided")
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("ISBN-10")
                            Text(book.isbn10 ?? "not provided")
                        }
                        Spacer()
                        VStack {
                            Text("ISBN-13")
                            Text(book.isbn13 ?? "not provided")
                        }
                        Spacer()
                    }

                    VStack {
                        Divider()
                        Text("Page Count")
                        if book.pageCount != nil {
                            Text(String(book.pageCount!))
                        } else {
                            Text("not provided")
                        }
                    }
                    VStack {
                        Divider()
                        Text("Description")
                        if book.description != nil || book.description != "" {
                            Text(book.description!)
                        } else {
                            Text("not provided")
                        }
                    }
                }
                .padding([.bottom, .horizontal])
    }
    
    var body: some View {
        VStack {
            HStack {
                AddResultButton(book: book)
                .buttonStyle(BorderlessButtonStyle()) // added to prevent conflict with showResultDetails button
                
                Button(action: { self.showResultDetails.toggle() }) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.authorNames())
                            .font(.caption)
                    }
                    .foregroundColor(Color.primary)
                    Spacer()
                    if self.showResultDetails {
                        Image(systemName: "chevron.up")
                    } else {
                        Image(systemName: "chevron.down")
                    }
                }.buttonStyle(BorderlessButtonStyle()) // added to prevent conflict with addResult button
            }
            
            if self.showResultDetails {
                self.displayResultData()
            }
        }
    }
}

struct SearchResultList: View {
    var body: some View {
        VStack {
            List {
                ForEach(AddBySearchForm.searchResults.books) { book in
                    SearchResultRow(book: book)
                }
            }
        }
    }
}

struct SearchResultList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultList()
    }
}
