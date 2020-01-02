//
//  ErrorAlertTests.swift
//  LibAwesomeTests
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import XCTest
@testable import LibAwesome

class ErrorAlertTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
    
    func testCanBeInstantiated() {
        let ea = ErrorAlert(reason: "Error")
        
        XCTAssertNotNil(ea)
    }
    
    func testCanGetReason() {
        let reason = "Error"
        let ea = ErrorAlert(reason: reason)
        
        XCTAssertEqual(ea.reason, reason)
    }
    
    func testIsIdentifiable() {
        let ea = ErrorAlert(reason: "Error")
        
        XCTAssertEqual(ea.id, "Error")
    }

}
