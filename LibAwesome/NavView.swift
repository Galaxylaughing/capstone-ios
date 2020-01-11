//
//  NavView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/11/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

enum TopViews {
    case home
    case settings
    
    case booklist
    case authorlist
    case serieslist
    case taglist        // TODO might be incorporated into home
    
    case bookdetail
    case authordetail
    case seriesdetail
    case tagdetail
}

struct NavView: View {
    @EnvironmentObject var env: Env
    
    @State var showBackButton = false
    static var stack: [TopViews] = [ .home ]

    var leadingView: some View {
         HStack {
            if (self.showBackButton && NavView.stack.count > 1) {
                Button(action: {
                    // pop twice because we want to go to the previous view (and last is the current view)
                    var prevView = NavView.stack.popLast() ?? .home
                    prevView = NavView.stack.last ?? .home
                    self.env.topView = prevView
                }) {
                    Image(systemName: "chevron.left.circle")
                }
            }
            NavButton(view: .home, icon: HOME_ICON)
        }
     }

    var trailingView: some View {
         HStack {
            NavButton(view: .settings, icon: SETTINGS_ICON)
        }
     }
    
    var detailsTrailingView: some View {
        HStack {
            if self.env.topView == .bookdetail {
                EditBookButton().environmentObject(BookDetailView.book)
            } else if self.env.topView == .seriesdetail {
                EditSeriesButton().environmentObject(SeriesDetailView.series)
            } else if self.env.topView == .tagdetail {
                EditTagButton()
            }
            if self.env.topView != .authordetail {
                Button(action: {}) {
                    DeleteIcon()
                }
            }
        }
    }

    // NavView body
    var body: some View {
        NavigationView {
            viewSwitch()
                .navigationBarTitle(Text(viewTitle()), displayMode: .inline)
                .navigationBarHidden(false)
                .navigationBarItems(leading: leadingView,
                                    trailing: self.getTrailingView()
                )
        }
    }
    
    func getTrailingView() -> AnyView {
        var view = AnyView(self.trailingView)
        if self.env.topView == .bookdetail
        || self.env.topView == .authordetail
        || self.env.topView == .seriesdetail
        || self.env.topView == .tagdetail {
            view = AnyView(self.detailsTrailingView)
        }
        return view
    }
    
    func turnOnBackButton() {
        DispatchQueue.main.async {
            self.showBackButton = true
        }
    }
    
    func viewSwitch() -> AnyView {
        if (self.env.topView == .home) {
            NavView.stack = [ .home ]
        } else if (self.env.topView != NavView.stack.last) {
            NavView.stack.append(self.env.topView)
        }
        var view: AnyView
        switch env.topView {
        case .settings:
            view = AnyView(SettingsView())
            
        case .booklist:
            self.turnOnBackButton()
            view = AnyView(BookListView())
        case .authorlist:
            self.turnOnBackButton()
            view = AnyView(AuthorListView())
        case .serieslist:
            self.turnOnBackButton()
            view = AnyView(SeriesListView())
        
        case .bookdetail:
            self.turnOnBackButton()
            view = AnyView(BookDetailView())
        case .authordetail:
            self.turnOnBackButton()
            view = AnyView(AuthorDetailView())
        case .seriesdetail:
            self.turnOnBackButton()
            view = AnyView(SeriesDetailView())
        case .tagdetail:
            self.turnOnBackButton()
            view = AnyView(TagDetailView())
            
        default:
            view = AnyView(HomeView()) // defaults to .home
        }
        return view
    }
    
    func viewTitle() -> String {
        var title = ""
        switch env.topView {
        case .settings:
            title = "Settings"
            
        case .booklist:
            title = "Books"
        case .authorlist:
            title = "Authors"
        case .serieslist:
            title = "Series"
            
        case .bookdetail:
            title = "Book Detail"
        case .authordetail:
            title = "Author Detail"
        case .seriesdetail:
            title = "Series Detail"
        case .tagdetail:
            title = "Tag Detail"
            
        default:
            title = "Home" // defaults to .home
        }
        return title
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
