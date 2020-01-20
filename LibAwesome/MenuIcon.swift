//
//  MenuIcon.swift
//  LibAwesome
//
//  Created by Sabrina on 1/20/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct MenuIcon: View {
    var image: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
            Image(systemName: self.image)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

struct MenuIcon_Previews: PreviewProvider {
    static var previews: some View {
        MenuIcon(image: "plus.circle.fill")
    }
}
