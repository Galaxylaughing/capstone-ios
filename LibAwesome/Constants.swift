//
//  Constants.swift
//  LibAwesome
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import Foundation
import SwiftUI

//let API_HOST = "http://127.0.0.1:8000/"
let API_HOST = "http://192.168.1.18:8000/"
//let API_HOST = "https://booktrackerapi.herokuapp.com/"

let GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/volumes?q="


// ICONS
let HOME_ICON = AnyView(Image(systemName: "house"))
let SETTINGS_ICON = AnyView(Image(systemName: "slider.horizontal.3"))

let BOOKLIST_ICON = AnyView(Text("Books"))
let AUTHORLIST_ICON = AnyView(Text("Authors"))
let SERIESLIST_ICON = AnyView(Text("Series"))
let SCANNER_ICON = AnyView(Image(systemName: "barcode.viewfinder"))
