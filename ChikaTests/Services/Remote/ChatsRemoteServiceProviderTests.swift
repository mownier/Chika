//
//  ChatsRemoteServiceProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class ChatsRemoteServiceProviderTests: XCTestCase {
    
    // CONTEXT: getInbox function should
    //   - return a .err result
    //   - .err info is 'inbox is empty'
    // GIVEN:
    //   - personID is empty
    func testGetInboxA() {
        let exp = expectation(description: "testGetInboxA")
        let service = ChatRemoteServiceProvider()
        let personID = ""
        service.getInbox(for: personID) { result in
            switch result {
            case .ok:
                XCTFail()
            
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "can not get inbox")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
