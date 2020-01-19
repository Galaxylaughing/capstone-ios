//
//  RatingButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct RatingButton: View {
    @EnvironmentObject var env: Env
    @State private var error: ErrorAlert?
    
    let rating: Rating
    let bookToUpdate: BookList.Book
    
    static func getRatingButtons(for book: BookList.Book) -> VStack<TupleView<(RatingButton, RatingButton, RatingButton, RatingButton, RatingButton, RatingButton)>> {
        return VStack {
            RatingButton(rating: Rating.five,       bookToUpdate: book)
            RatingButton(rating: Rating.four,       bookToUpdate: book)
            RatingButton(rating: Rating.three,      bookToUpdate: book)
            RatingButton(rating: Rating.two,        bookToUpdate: book)
            RatingButton(rating: Rating.one,        bookToUpdate: book)
            RatingButton(rating: Rating.unrated,    bookToUpdate: book)
        }
    }
    
    fileprivate func isCurrentRating() -> Bool {
        return self.bookToUpdate.rating == self.rating
    }
    
    var body: some View {
        Button(action: { self.changeRating() }) {
            HStack {
                Text(self.rating.getEmojiStarredRating())
                if self.isCurrentRating() {
                    Image(systemName: "checkmark.circle")
                }
            }
        }
        .disabled(self.isCurrentRating())
    }
    
    func changeRating() {
        let new_rating = self.rating
        let book_id = self.bookToUpdate.id
     
        // PUT rating to API
        let response = APIHelper.putRating(
            token: self.env.user.token,
            bookId: book_id,
            rating: new_rating.rawValue
        )
     
        if response["success"] != nil {
            // find book in environment booklist and change it's rating
            let tempBookList = self.env.bookList
            if let index = tempBookList.books.firstIndex(where: {$0.id == self.bookToUpdate.id}) {
                tempBookList.books[index].rating = new_rating
            }
            // change rating of the book in the environment
            let tempBook = self.env.book
            tempBook.rating = new_rating
            DispatchQueue.main.async {
                self.env.bookList = tempBookList
                self.env.book = tempBook
            }
        } else if response["error"] != nil {
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "unknown error")
        }
        
    }
    
}

struct RatingButton_Previews: PreviewProvider {
    static var bookToUpdate = BookList.Book()
    
    static var previews: some View {
        RatingButton(
            rating: Rating.three,
            bookToUpdate: self.bookToUpdate
        )
    }
}
