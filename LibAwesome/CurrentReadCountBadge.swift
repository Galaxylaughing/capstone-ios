//
//  CurrentReadCountBadge.swift
//  LibAwesome
//
//  Created by Sabrina on 1/16/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct CurrentReadCountBadge: View {
    @EnvironmentObject var env: Env
    
    var body: some View {
        VStack {
            Text(String(self.env.currentReadsCount))
                .font(.caption)
                .padding(3)
                .foregroundColor(Color.white)
                .padding(.horizontal, 2)
                .background(
                    Capsule()
                        .fill(Color.blue)
                )
        }
    }
}

struct CurrentReadCountBadge_Previews: PreviewProvider {
    static func makeEnv() -> Env {
        let previewEnv = Env()
        previewEnv.currentReadsCount = 1
        
        return previewEnv
    }
    static var env = makeEnv()
    
    static var previews: some View {
        CurrentReadCountBadge()
        .environmentObject(self.env)
    }
}
