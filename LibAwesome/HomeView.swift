//
//  HomeView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            NavButton(view: .booklist, icon: BOOKLIST_ICON)
            NavButton(view: .authorlist, icon: AUTHORLIST_ICON)
            NavButton(view: .serieslist, icon: SERIESLIST_ICON)

            Spacer()
            TagListView()
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
