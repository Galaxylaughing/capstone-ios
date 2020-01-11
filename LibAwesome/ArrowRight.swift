//
//  ArrowRight.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ArrowRight: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(Color.secondary)
    }
}

struct ArrowRight_Previews: PreviewProvider {
    static var previews: some View {
        ArrowRight()
    }
}
