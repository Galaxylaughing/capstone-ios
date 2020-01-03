//
//  TagsView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct TagsView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Tags")
                    .font(.title)
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("# owned")
                    Text("# wishlist")
                    
                    VStack(alignment: .leading) {
                        Text("series")
                            .font(.headline)
                            .padding(.vertical)
                        Text("# mistborn")
                        Text("# gone")
                        Text("# thrawn-trilogy")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("univeres")
                            .font(.headline)
                            .padding(.vertical)
                        Text("# cosmere")
                        Text("# star-wars")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("my tags")
                            .font(.headline)
                            .padding(.vertical)
                        Text("# fiction")
                        Text("  # fantasy")
                        Text("    # historical-fantasy")
                        Text("      # victorian")
                        Text("    # alternate-history")
                        Text("  # contemporary")
                        Text("  # sci-fi")
                        Text("  # historical")
                        Text("# nonfiction")
                    }
                }
            }
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView()
    }
}
