//
//  AppDelegateTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class AppDelegateTests: XCTestCase {
    
    // CONTEXT: handleUITesting function should return false
    // given that ProcessInfo arguments do not contain
    // 'ForceInitialScene'
    func testHandleUITestingA() {
        let info = ProcessInfoMock()
        let delegate = AppDelegate()
        info.mockArguments = []
        let ok = delegate.handleUITesting(info: info)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: handleUITesting funtion should return true
    // diven that ProcessInfo arguments contains 'ForceInitialScene'
    func testHandleUITestingB() {
        let info = ProcessInfoMock()
        let delegate = AppDelegate()
        info.mockArguments = ["ForceInitialScene"]
        let ok = delegate.handleUITesting(info: info)
        XCTAssertTrue(ok)
    }
}
