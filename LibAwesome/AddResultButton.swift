//
//  AddResultButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/14/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct AddResultButton: View {
    var book: BookList.Book
    
    var body: some View {
        Button(action: { self.addBook() }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.green)
        }
    }
    
    func addBook() {
        print("adding")
    }
}

struct AddResultButton_Previews: PreviewProvider {
    static var previews: some View {
        AddResultButton(book: BookList.Book())
    }
}
