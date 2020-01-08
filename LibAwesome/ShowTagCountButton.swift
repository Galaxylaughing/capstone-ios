//
//  ShowTagCountButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/8/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ShowTagCountButton: View {
    @Binding var showCount: Bool
    
    var body: some View {
        Button(action: {self.showCount.toggle()}) {
            if self.showCount {
                Image(systemName: "eye")
            } else {
                Image(systemName: "eye.slash")
            }
        }
    }
}

struct ShowTagCountButton_Previews: PreviewProvider {
    @State static var showCount = true
    
    static var previews: some View {
        ShowTagCountButton(showCount: self.$showCount)
    }
}
