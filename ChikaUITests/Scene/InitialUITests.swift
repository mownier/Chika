//
//  InitialUITests.swift
//  ChikaUITests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest

class InitialUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testShouldShowSignIn() {
        let app = XCUIApplication()
        app.buttons["Sign In"].tap()
        XCTAssertTrue(app.otherElements["Sign In Scene View"].exists)
    }
    
    func testShouldShowRegister() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
    }
}
