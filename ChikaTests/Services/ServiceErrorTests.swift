//
//  ServiceErrorTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class ServiceErrorTests: XCTestCase {
    
    func testInit() {
        let error = ServiceError("error occurred")
        XCTAssertEqual(error.message, "error occurred")
    }
    
    func testDescription() {
        let error = ServiceError("error occurred")
        XCTAssertEqual("SERVICE_ERR: error occurred", "\(error)")
        XCTAssertEqual("SERVICE_ERR: error occurred", error.description)
    }
}
