//
//  SearchResultList.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SearchResultRow: View {
    @State private var showResultDetails: Bool = false
    var book: BookList.Book
    
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
                    .buttonStyle(BorderlessButtonStyle())
                
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
                }.buttonStyle(BorderlessButtonStyle())
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
    
    /*
    // POST book to API
    let googleBook = googleBookList.books[0]
    let bookToSend: BookListService.Book = BookListService.Book(
        id: 0,
        title: googleBook.title,
        authors: googleBook.authors,
        position_in_series: nil,
        series: nil,
        publisher: googleBook.publisher,
        publication_date: googleBook.publicationDate,
        isbn_10: googleBook.isbn10,
        isbn_13: googleBook.isbn13,
        page_count: googleBook.pageCount,
        description: googleBook.description,
        tags: [])
    let response = APIHelper.postBook(
        token: self.env.user.token,
        book: bookToSend)
    
    if response["success"] != nil {
        print("came back from POSTING with success")
        // add new book to environment BookList
        if let newBook = EncodingHelper.makeBook(data: response["success"]!) {
            let bookList = self.env.bookList
            bookList.books.append(newBook)
            Env.setEnv(in: self.env, to: bookList)
            DispatchQueue.main.async {
                self.env.book = newBook
                self.env.topView = .bookdetail
            }
        }
        // should dismiss sheet if success
        self.showForm = false
    } else if response["error"] != nil {
        // should pop up error if failure
        self.error = ErrorAlert(reason: response["error"]!)
    } else {
        self.error = ErrorAlert(reason: "Unknown error")
    }
     */
}

struct SearchResultList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultList()
    }
}
