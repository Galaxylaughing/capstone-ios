//
//  SearchResultAddButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/15/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SearchResultAddButton: View {
    @EnvironmentObject var env: Env
    @Binding var bookChecklist: [BookCheckListItem]
    @State private var error: ErrorAlert?
    
    var body: some View {
        Button(action: { self.addBooks() }) {
            HStack {
                Text("Add to Library")
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding(16)
            .background(Color.green)
            .cornerRadius(25)
            .foregroundColor(Color.white)
            .padding(10)
            .padding(.top, 5)
        }
        .alert(item: $error, content: { error in
            AlertHelper.alert(reason: error.reason)
        })
//        .buttonStyle(BorderlessButtonStyle())
    }
    
    //    func unBuildBookChecklist() {
    //        // assign correct books to self.booksToAdd based on checklist
    //        for item in self.bookChecklist {
    //            if item.isChecked {
    //                self.booksToAdd.books.append(item.content)
    //            }
    //        }
    //    }
    
    func addBooks() {
        print("adding")
        
        /*
        // POST selected book to API
        let bookToSend: BookListService.Book = BookListService.Book(from: self.book)
        
        print(bookToSend.title)
        print("  \(String(describing: bookToSend.position_in_series))")
        print("  \(String(describing: bookToSend.series))")
        print("  \(bookToSend.tags)")
        
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
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
        */
    }
}

struct SearchResultAddButton_Previews: PreviewProvider {
    @State static var bookChecklist: [BookCheckListItem] = []
    
    static var previews: some View {
        SearchResultAddButton(bookChecklist: self.$bookChecklist)
    }
}
