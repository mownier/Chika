//
//  RegisterUITests.swift
//  ChikaUITests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest

class RegisterUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments.append(LaunchArgument.forceInitialScene.rawValue)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        let app = XCUIApplication()
        if let index = app.launchArguments.index(of: LaunchArgument.forceInitialScene.rawValue) {
            app.launchArguments.remove(at: index)
        }
    }
    
    // CONTEXT: RegisterScene  must appear given that the
    // register button in InitialScene is tapped
    func testViewShouldAppear() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        XCTAssertTrue(app.otherElements["Register Scene View"].exists)
    }
    
    // CONTEXT: RegisterScene must disappear given that the
    // back button of the scene is tapped
    func testViewShouldDisappear() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back Button"]/*[[".otherElements[\"Register Scene View\"].buttons[\"Back Button\"]",".buttons[\"Back Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.otherElements["Register Scene View"].exists)
    }
    
    // CONTEXT: Error alert must appear given that the
    // email and pass input's text are empty
    func testErrorAlertShouldAppear() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Register Button"]/*[[".otherElements[\"Register Scene View\"].buttons[\"Register Button\"]",".buttons[\"Register Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.alerts["Error"].exists)
    }
    
    // CONTEXT: Error alert must disappear given that the
    // OK button of the alert is tapped
    func testErrorAlertShouldDisappear() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Register Button"]/*[[".otherElements[\"Register Scene View\"].buttons[\"Register Button\"]",".buttons[\"Register Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Error"].buttons["OK"].tap()
        XCTAssertFalse(app.alerts["Error"].exists)
    }
}
