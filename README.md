# capstone-ios -- Project Overview

This is the front-end of my capstone project, the details of which can be found [here](https://gist.github.com/Galaxylaughing/52fbe0aea39b01cd202cfce2dd982ae5). 
The back-end can be found [here](https://github.com/Galaxylaughing/capstone-api).

# Installation

## XCode

If you fork and clone this repo, you can open the project in XCode by `cd`ing into the root directory, which will show three folders and a `LibAwesome.xcodeproj` file. 

You can open the project by:
1. entering the command `open LibAwesome.xcodeproj` 
2. entering the command `open .` to open the directory in a Finder window and double-clicking on the `LibAwesome.xcodeproj` file.

## CodeScanner Dependency

This project uses the Swift package [CodeScanner](https://github.com/twostraws/CodeScanner) to scan barcodes.

When you open this `LibAwesome.xcodeproj`, the CodeScanner dependency should already be installed.

If CodeScanner is not already installed, installation instructions from the maker of this package can be found [here](https://www.hackingwithswift.com/books/ios-swiftui/scanning-qr-codes-with-swiftui), and the important details are repeated below.

### Adding CodeScanner To XCode

In the opened XCode project, go to the File menu > Swift Packages > Add Package Dependency. 
You will be prompted to enter the package's URL, which is `https://github.com/twostraws/CodeScanner`. 
Click "Next". The defaults for version rules, "Up to Next Major", should be sufficient. Click "Finish" to import the package into the project.

When properly imported, CodeScanner will show up in the XCode Project Navigator in a section titled "Swift Package Dependencies".

### Modifying Info.plist

For security purposes, the app must ask permission from the user to use the camera. If you had to install CodeScanner, you should also complete this step. Otherwise, it should be completed already.

Open Info.plist and right-click in any row for options. From the options, select "Add Row" and input "Privacy - Camera Usage Description" as the Key and "This app would like to use the camera to scan ISBN barcodes" as the Value.

## APIs

This project uses two APIs. One is the [Google Books API](https://developers.google.com/books), 
which is used to facillitate the app's search functionality.

The main API that provides the app's backend can be found [here](https://github.com/Galaxylaughing/capstone-api). This API has been deployed on [Heroku](https://booktrackerapi.herokuapp.com/helloworld/).

The URLs to call these APIs are listed in the Constants.swift file.

# Running the App

Click the play button, the one with the "▶️" symbol, on XCode's top bar to build the app and open it in the simulator. This app has been tested primarily on an iPhone 7 and iPad Pro 9.7" and using the iPhone 8 simulator.

# Connecting to A Local Database

You may want to utilize a local database rather than the deployed Heroku database. This can be achieved by opening the XCode project and selecting Constants.swift in the Project Navigator.

You will see the following:

```swift
// API URLS
let API_HOST = "https://booktrackerapi.herokuapp.com/"
let GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/volumes?q="
```

Comment out the API_HOST variable and add a new API_HOST variable. Set it to the url you would like to connect to, for example your localhost url:

```swift
// API URLS
// let API_HOST = "https://booktrackerapi.herokuapp.com/"
let API_HOST = "http://127.0.0.1:8000/"
let GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/volumes?q="
```

Django's local server runs on port 8000, hence the `:8000`. Replace this with the port you would like to use if you want to run on something else.
