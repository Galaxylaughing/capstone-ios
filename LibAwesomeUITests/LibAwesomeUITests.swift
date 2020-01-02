//
//  LibAwesomeUITests.swift
//  LibAwesomeUITests
//
//  Created by Sabrina on 12/31/19.
//  Copyright © 2019 SabrinaLowney. All rights reserved.
//

import XCTest

class LibAwesomeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        /*
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        // -- login
        let usernameTextField = tablesQuery.textFields["username"]
        usernameTextField.tap()
        
        let passwordSecureTextField = tablesQuery.secureTextFields["password"]
        passwordSecureTextField.tap()
        
        tablesQuery.buttons["Login"].tap()
        
        // -- click to new tab called 'Tags'
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tags"].tap()
        
        // -- click logout button
        app.buttons["logout"].tap()
        */
        
        let table = XCUIApplication().tables
        XCTAssertGreaterThan(table.cells.count, 0)
        
        // -- the LoginForm has 4 cells:
        // -- + HStack for username input
        // -- + HStack for password input
        // -- + Button for Login
        // -- + Section with NavigationLink to SignUpForm
        XCTAssertEqual(table.cells.count, 4)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    /*
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    */
}
