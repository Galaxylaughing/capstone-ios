//
//  SearchResultChecklist.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SearchResultChecklistRow: View {
    var book: BookList.Book
    @Binding var isChecked: Bool
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
                /*
                AddResultButton(book: book)
                .buttonStyle(BorderlessButtonStyle()) // added to prevent conflict with showResultDetails button
                */
                if self.isChecked {
                    Image(systemName: "checkmark.square.fill")
                } else {
                    Image(systemName: "square")
                }
                
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

class BookCheckListItem: Identifiable {
    var id: Int {
        return content.id
    }
    var isChecked: Bool
    var content: BookList.Book

    init(isChecked: Bool = false, content: BookList.Book) {
        self.isChecked = isChecked
        self.content = content
    }
}

struct BookCheckListRow: View {
    @State var item: BookCheckListItem
    @State var isChecked: Bool

    var body: some View {
        HStack {
            SearchResultChecklistRow(book: self.item.content, isChecked: self.$isChecked)
        }
        .gesture(
            TapGesture().onEnded({
                // toggle item to update CheckList view
                self.item.isChecked.toggle();
                // toggle boolean to update self view
                self.isChecked.toggle();
            })
        )
    }
}

struct BookCheckList: View {
    @Binding var list: [BookCheckListItem]

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(list) { item in
                    BookCheckListRow(item: item, isChecked: item.isChecked)
                        .gesture(
                            TapGesture().onEnded({
                                item.isChecked.toggle()
                            })
                        )
                }
            }
        }
    }
}

struct BookResults: View {
    @Binding var bookChecklist: [BookCheckListItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            BookCheckList(list: self.$bookChecklist)
        }
    }
}

struct SearchResultChecklist: View {
    @State var bookChecklist: [BookCheckListItem] = []
    
    func buildBookChecklist() {
        var checklist: [BookCheckListItem] = []
        // convert book results to checklist items
        for book in AddBySearchForm.searchResults.books {
            let checklistitem = BookCheckListItem(isChecked: false, content: book)
            checklist.append(checklistitem)
        }
        self.bookChecklist = checklist
    }
    
    var body: some View {
        VStack(alignment: .center) {
            SearchResultAddButton(bookChecklist: self.$bookChecklist)
            Form {
                BookCheckList(list: self.$bookChecklist)
            }
        }
        .onAppear(perform: { self.buildBookChecklist() })
    }
}

struct SearchResultChecklist_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultChecklist()
    }
}
