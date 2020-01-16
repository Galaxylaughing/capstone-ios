//
//  HomeNavButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/15/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct HomeNavButton: View {
    let view: TopViews
    let icon: AnyView
    
    var body: some View {
        NavButton(view: self.view, icon: self.icon)
        .foregroundColor(Color.white)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.blue)
        )
        .padding(5)
    }
}

struct HomeNavButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavButton(view: .home, icon: HOME_ICON)
    }
}
