//
//  LibraryView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var currentUser: User
    @EnvironmentObject var bookList: BookList
    
    var body: some View {
        VStack {
            HStack {
                Text("Library")
                    .font(.title)
                Spacer()
                Text("options")
            }
            
            List(bookList.books, id: \.title) { book in
                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title)
                        VStack {
                            ForEach(book.authors, id: \.name) { author in
                                Text(author.name)
                            }
                        }
                    }
                    Spacer()
                    Text("in progress")
                }
            }
        }
    }

}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}
