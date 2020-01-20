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
    
    case currentreads
    case statushistory
    
    case googleresults
    case scanner
}

struct NavView: View {
    @EnvironmentObject var env: Env
    
    @State var showBackButton = false
    static var stack: [TopViews] = [ .home ]
    
    static func goBack(env: Env) {
        // pop twice because we want to go to the previous view (and last is the current view)
        var prevView = NavView.stack.popLast() ?? .home
        prevView = NavView.stack.last ?? .home
        
        if (prevView == .tagdetail && env.tag.books.count == 0)
        || (prevView == .authordetail && !env.book.authors.contains(AuthorDetailView.author.name))
        || (prevView == .googleresults) {
            prevView = NavView.stack.popLast() ?? .home
            prevView = NavView.stack.last ?? .home
        }
        
        env.topView = prevView
    }

    var leadingView: some View {
         HStack {
            if (self.showBackButton && NavView.stack.count > 1) {
                Button(action: {
                    NavView.goBack(env: self.env)
                }) {
                    Image(systemName: "chevron.left.circle")
                    .padding(.trailing)
                }
            }
            NavButton(view: .home, icon: HOME_ICON)
        }
     }

    var trailingView: some View {
         HStack {
            CurrentReadsButton()
            NavButton(view: .settings, icon: SETTINGS_ICON)
        }
     }
    
    var detailsTrailingView: some View {
        HStack {
            // Edit Button
            if self.env.topView == .bookdetail {
                EditBookButton()
            } else if self.env.topView == .seriesdetail {
                EditSeriesButton().environmentObject(SeriesDetailView.series)
            } else if self.env.topView == .tagdetail && TagDetailView.showEditButtons {
                EditTagButton()
            }
            
            // Delete Button
            if self.env.topView != .authordetail
                && (self.env.topView != .tagdetail || TagDetailView.showEditButtons) {
                
                if self.env.topView == .bookdetail {
                    DeleteBookButton().padding(.leading)
                } else if self.env.topView == .seriesdetail {
                    DeleteSeriesButton().padding(.leading)
                } else if self.env.topView == .tagdetail && TagDetailView.showEditButtons {
                    DeleteTagButton().padding(.leading)
                }
                
            }
        }
    }
    
    var listTrailingView: some View {
        HStack {
            // edit button
            if self.env.topView == .booklist {
                CurrentReadsButton()
                EditButton()
                    .padding(.leading)
            } else {
                CurrentReadsButton()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getTrailingView() -> AnyView {
        var view = AnyView(self.trailingView)
        if self.env.topView == .bookdetail
        || self.env.topView == .authordetail
        || self.env.topView == .seriesdetail
        || self.env.topView == .tagdetail {
            view = AnyView(self.detailsTrailingView)
        } else if self.env.topView == .booklist
        || self.env.topView == .serieslist
        || self.env.topView == .authorlist {
            view = AnyView(self.listTrailingView)
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
            
        case .currentreads:
            self.turnOnBackButton()
            view = AnyView(CurrentReadsList())
        case .statushistory:
            self.turnOnBackButton()
            view = AnyView(StatusHistoryView())
            
        case .googleresults:
            self.turnOnBackButton()
            view = AnyView(SearchResultList())
        case .scanner:
            view = AnyView(BarcodeScanner())
            
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
            
        case .currentreads:
            title = "Currently Reading"
        case .statushistory:
            title = "Status History"
            
        case .googleresults:
            title = "Results"
        case .scanner:
            title = "Barcode Scanner"
            
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
