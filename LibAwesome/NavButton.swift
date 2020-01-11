//
//  NavButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct NavButton: View {
    @EnvironmentObject var env: Env
    
    let view: TopViews
    let icon: AnyView

    var body: some View {
        Button(action: {
            self.env.topView = self.view
        }) {
            icon
        }.disabled(self.env.topView == view)
    }
}

struct NavButton_Previews: PreviewProvider {
    static var previews: some View {
        NavButton(view: .home, icon: HOME_ICON)
          .environmentObject(Env())
    }
}
