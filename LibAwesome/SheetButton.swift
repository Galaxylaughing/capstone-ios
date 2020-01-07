//
//  SheetButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SheetButton: View {
    @State var label: String
    @State var sheet: AnyView
    
    @State var showForm: Bool = false
    @State var showLabel: Bool = false
    @State var icon: AnyView = AnyView(AddIcon())
    
    var body: some View {
        Button(action: { self.showForm.toggle() }) {
            if self.showLabel {
                Text(self.label)
            } else {
                self.icon
            }
        }
        .sheet(isPresented: $showForm) {
            self.sheet
        }
    }
}

struct SheetButton_Previews: PreviewProvider {
    @State static var showForm = true
    
    static var previews: some View {
        SheetButton(label: "Add Item", sheet: AnyView(AddBookForm(showForm: $showForm)))
    }
}


//struct AddButton: View {
//    @EnvironmentObject var env: Env
//    @State var showForm: Bool = false
//    @State var showLabel: Bool = false
//
//    var body: some View {
//        Button(action: { self.showForm.toggle() }) {
//            if self.showLabel {
//                Text("Add Book")
//            } else {
//                AddIcon()
//            }
//        }.sheet(isPresented: $showForm) {
//            AddBookForm(showForm: self.$showForm)
//                .environmentObject(self.env)
//        }
//    }
//}
//
//struct AddButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddButton()
//    }
//}



//struct AddSeriesButton: View {
//    @EnvironmentObject var env: Env
//    @State var showForm: Bool = false
//    @State var showLabel: Bool = false
//
//    var body: some View {
//        Button(action: { self.showForm.toggle() }) {
//            if self.showLabel {
//                Text("Add Series")
//            } else {
//                AddIcon()
//            }
//        }.sheet(isPresented: $showForm) {
//            AddSeriesForm(showForm: self.$showForm)
//                .environmentObject(self.env)
//        }
//    }
//}
//
//struct AddSeriesButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSeriesButton()
//    }
//}


//struct EditBookButton: View {
//    @EnvironmentObject var env: Env
//    @EnvironmentObject var book: BookList.Book
//    @State var showEditForm: Bool = false
//
//    var body: some View {
//        Button(action: { self.showEditForm.toggle() }) {
//            HStack {
//                Text("edit")
//                    .font(.caption)
//                Image(systemName: "pencil")
//            }
//        }.sheet(isPresented: $showEditForm) {
//            EditBookForm(showEditForm: self.$showEditForm, bookToEdit: BookList.Book(id: self.book.id, title: self.book.title, authors: self.book.authors))
//                .environmentObject(self.env)
//                .environmentObject(self.book)
//        }
//    }
//}
