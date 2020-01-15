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
//        .onAppear(perform: {self.buildTagChecklist()})
    }
}


//struct BookCheckListRow: View {
//    @State var item: BookCheckListItem
//    @State var isChecked: Bool
//
//    var body: some View {
//        HStack {
//            if self.isChecked {
//                Image(systemName: "checkmark.square.fill")
//            } else {
//                Image(systemName: "square")
//            }
//            Text(self.item.content.title)
//        }
//        .gesture(
//            TapGesture().onEnded({
//                // toggle item to update CheckList view
//                self.item.isChecked.toggle();
//                // toggle boolean to update self view
//                self.isChecked.toggle();
//            })
//        )
//    }
//}

//class BookCheckListItem: Identifiable {
//    var id: Int {
//        return content.id
//    }
//    var isChecked: Bool
//    var content: BookList.Book
//
//    init(isChecked: Bool = false, content: BookList.Book) {
//        self.isChecked = isChecked
//        self.content = content
//    }
//}

//struct BookCheckList: View {
//    @Binding var list: [BookCheckListItem]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            List {
//                ForEach(list) { item in
//                    CheckListRow(item: item, isChecked: item.isChecked)
//                        .gesture(
//                            TapGesture().onEnded({
//                                item.isChecked.toggle()
//                            })
//                        )
//                }
//            }
//        }
//    }
//}


//    @State var bookChecklist: [BookCheckListItem] = []
//    @State private var newBook: BookList.Book = BookList.Book()
//
//    func buildBookChecklist() {
//        var checklist: [BookCheckListItem] = []
//        // convert book results to checklist items
//        for book in AddBySearchForm.searchResults.books {
//            let checklistitem = BookCheckListItem(isChecked: false, content: book)
//            checklist.append(checklistitem)
//        }
//        self.tagChecklist = checklist
//    }
//
//    func unBuildBookChecklist() {
//        // assign correct books to self.booksToAdd based on checklist
//        for item in self.bookChecklist {
//            if item.isChecked {
//                self.booksToAdd.books.append(item.content)
//            }
//        }
//    }
//
//    func addFromBookResults() -> some View {
//        return BookResults(
//            bookChecklist: self.$bookChecklist
//        )
//    }


//struct BookResults: View {
//    @Binding var bookChecklist: [BookCheckListItem]
//
//    var body: some View {
//        Section(header: Text("add books")) {
//            VStack(alignment: .leading) {
//                CheckList(list: self.$bookChecklist)
//            }
//        }
//    }
//}

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
