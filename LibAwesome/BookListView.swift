//
//  BookListView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/6/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct BookListView: View {
    @Environment(\.editMode) var mode
    @EnvironmentObject var env: Env
    
    // from https://stackoverflow.com/questions/56706188/how-does-one-enable-selections-in-swiftuis-list
    // and https://stackoverflow.com/questions/57617524/swiftui-editbutton-action-on-done
    @State var selectKeeper = Set<Int>()
    
    @State var error: String?
    @State var showConfirm: Bool = false
    @State private var bookToDelete: Int = 0
    @State private var bookTitleToDelete: String = ""
    
    func getSortedBookList() -> [BookList.Book] {
        var booklist = self.env.bookList.books
        if self.env.selectedStatusFilter != nil {
            booklist = BookHelper.filterByStatus(list: booklist, status: self.env.selectedStatusFilter!)
        }
        booklist = booklist.sorted(by: {$0 < $1})
        return booklist
    }
    
    fileprivate func bookRow(for book: BookList.Book) -> some View {
        return
            Button(action: {
                self.env.book = book
                self.env.topView = .bookdetail
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title)
                        HStack {
                            Text(book.authorNames())
                            Spacer()
                            if book.rating != Rating.unrated {
                                book.rating.getEmojiStarredRating()
                                .foregroundColor(Color.yellow)
                            }
                        }
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
    
    fileprivate func listBooks() -> AnyView {
        return AnyView(
            List(selection: $selectKeeper) {
                ForEach(self.getSortedBookList(), id: \.id) { book in
                    self.bookRow(for: book)
                }
                .onDelete(perform: self.displayConfirm)
            }
                // from https://www.hackingwithswift.com/quick-start/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically
                .alert(isPresented: self.$showConfirm) {
                    if self.error == nil {
                        return Alert(title: Text("Delete '\(self.bookTitleToDelete)'"),
                                     message: Text("Are you sure?"),
                                     primaryButton: .destructive(Text("Delete")) {
                                        self.swipeDeleteBook()
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
        )
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack {
                Section {
                    VStack {
                        FilterChoicesButton()
                            .padding([.horizontal, .top])
                        Divider()
                    }
                }
                Section {
                    self.listBooks()
                }
            }
            if self.mode?.wrappedValue == .active {
                MassDeleteButton(itemsToDelete: self.selectKeeper, showConfirm: self.$showConfirm, error: self.$error)
                    .padding(10)
            } else {
                AddButton()
                    .padding(10)
            }
        }
        .navigationBarTitle("Library", displayMode: .large)
    }
    
    func displayConfirm(at offsets: IndexSet) {
        let book = env.bookList.books.sorted(by: {$0 < $1})[offsets.first!]
        self.bookToDelete = book.id
        self.bookTitleToDelete = book.title
        self.showConfirm = true
    }
    
    func swipeDeleteBook() {
        self.showConfirm = false
        
        // make DELETE request
        let response = APIHelper.deleteBook(token: self.env.user.token, bookId: self.bookToDelete)
        
        if response["success"] != nil {            
            // remove book from environment
            if let indexToDelete = self.env.bookList.books.firstIndex(where: {$0.id == self.bookToDelete}) {
                let bookList = self.env.bookList
                bookList.books.remove(at: indexToDelete)
                
                Env.setEnv(in: self.env, to: bookList)
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

struct BookListView_Previews: PreviewProvider {
    static var exampleBook1 = BookList.Book(
        id: 1,
        title: "Good Omens: The Nice and Accurate Prophecies of Agnes Nutter, Witch",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
        ],
        rating: Rating.four
    )
    static var exampleBook2 = BookList.Book(
        id: 2,
        title: "A Great and Terrible Beauty",
        authors: [
            "Libba Bray"
        ],
        rating: Rating.three
    )
    static var exampleBook3 = BookList.Book(
        id: 3,
        title: "Spinning Silver",
        authors: [
            "Naomi Novik"
        ],
        rating: Rating.five
    )
    static var exampleBook4 = BookList.Book(
        id: 4,
        title: "The Warrior's Apprentice",
        authors: [
            "Lois McMaster Bujold"
        ],
        rating: Rating.unrated
    )
    static var bookList = BookList(books: [exampleBook1, exampleBook2, exampleBook3, exampleBook4])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        BookListView()
            .environmentObject(env)
    }
}
