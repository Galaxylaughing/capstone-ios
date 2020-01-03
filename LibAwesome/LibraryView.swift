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
    
    struct Book: Identifiable {
        var id: Int
        var title: String
        var author: String
        var status: String
    }
    
    private var bookList = [
        Book(id: 0,
             title: "The Golem and the Jinni",
             author: "Helene Wrecker",
             status: "complete"),
        Book(id: 1,
             title: "Anne of Green Gables",
             author: "L.M. Montgomery",
             status: "in progress"),
        Book(id: 2,
             title: "The Vanishing Stair",
             author: "Maureen Johnson",
             status: "to read"),
    ]
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Library")
                    .font(.title)
                Spacer()
                Text("options")
            }
            
            List(bookList) { book in
                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.author)
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
