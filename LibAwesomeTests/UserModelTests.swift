//
//  UserModelTests.swift
//  LibAwesomeTests
//
//  Created by Sabrina on 1/2/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import XCTest
@testable import LibAwesome

class UserModelTests: XCTestCase {

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
    
    func testEmptyUserCanBeCreated() {
        let newUser = User()
        
        // new user exists
        XCTAssertNotNil(newUser)
        // new user has empty properties
        XCTAssertNil(newUser.username)
        XCTAssertNil(newUser.token)
    }
     */
    
    func testUsernameCanBeAssigned() {
        let newUser = User()
        let username = "Username"
        
        newUser.username = username
        
        XCTAssertEqual(newUser.username, username)
    }
    
    func testUsernameCanBeReassigned() {
        let newUser = User()
        let newUsername = "NewUsername"
        
        newUser.username = "Username"
        newUser.username = newUsername
        
        XCTAssertEqual(newUser.username, newUsername)
    }

}
