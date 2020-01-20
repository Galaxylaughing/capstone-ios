//
//  ShowPasswordButton.swift
//  LibAwesome
//
//  Created by Sabrina on 1/19/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct ShowPasswordButton: View {
    @Binding var showPass: Bool
    
    var body: some View {
        Button(action: {self.showPass.toggle()}) {
            if self.showPass {
                Image(systemName: "eye")
            } else {
                Image(systemName: "eye.slash")
            }
        }
    }
}

struct ShowPasswordButton_Previews: PreviewProvider {
    @State static var showPass = true
    
    static var previews: some View {
        ShowPasswordButton(showPass: self.$showPass)
    }
}
