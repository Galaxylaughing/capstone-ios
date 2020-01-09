//
//  TagBubble.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TagBubble: View {
    let text: String
    
    var body: some View {
        Text(self.text)
            .foregroundColor(Color.white)
            .padding([.leading, .trailing], 15)
            .background(Color.blue)
            .cornerRadius(20)
    }
}

struct TagBubble_Previews: PreviewProvider {
    static var previews: some View {
        TagBubble(text: "tag_name")
    }
}
