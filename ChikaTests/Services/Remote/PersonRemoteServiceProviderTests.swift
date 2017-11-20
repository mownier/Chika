//
//  PersonRemoteServiceProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class PersonRemoteServiceProviderTests: XCTestCase {
    
    // CONTEXT: add function should return an error result given
    // that the reference is not ok
    func testAddA() {
        let exp = expectation(description: "testAddA")
        let email = "me@me.com"
        let id = "meID"
        let mockDatabase = FirebaseDatabaseMock()
        let service = PersonRemoteServiceProvider(database: mockDatabase)
        mockDatabase.mockReference.isOK = false
        service.add(email: email, id: id) { result in
            switch result {
            case .ok:
                XCTFail()
            
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: add function should return an ok result given
    // that the reference is ok
    func testAddB() {
        let exp = expectation(description: "testAddA")
        let email = "me@me.com"
        let id = "meID"
        let mockDatabase = FirebaseDatabaseMock()
        let service = PersonRemoteServiceProvider(database: mockDatabase)
        mockDatabase.mockReference.isOK = true
        service.add(email: email, id: id) { result in
            switch result {
            case .err:
                XCTFail()
                
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
