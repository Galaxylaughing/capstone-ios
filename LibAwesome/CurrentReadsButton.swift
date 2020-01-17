//
//  CurrentReadsButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/17/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct CurrentReadsButton: View {
    @EnvironmentObject var env: Env
    private var view: TopViews = .currentreads
    
    var body: some View {
        Button(action: {
            self.env.topView = self.view
        }) {
            CurrentReadCountBadge()
        }.disabled(self.env.topView == self.view)
    }
}

struct CurrentReadsButton_Previews: PreviewProvider {
    static var previews: some View {
        CurrentReadsButton()
    }
}
