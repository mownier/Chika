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
    
    // CONTEXT: getInbox function should
    //   - return a reversed array of Chat
    // GIVEN:
    //   - personID is not empty
    //   - inboxQuery returns a non-empty array
    func testGetInboxB() {
        let exp = expectation(description: "testGetInboxB")
        let inboxQuery = InboxRemoteQueryMock()
        let service = ChatRemoteServiceProvider(inboxQuery: inboxQuery)
        let personID = "person:1"
        var chat1 = Chat()
        var chat2 = Chat()
        var chat3 = Chat()
        chat1.id = "chat:1"
        chat2.id = "chat:2"
        chat3.id = "chat:3"
        let mockChats: [Chat] = [chat1, chat2, chat3]
        inboxQuery.mockChats = mockChats
        service.getInbox(for: personID) { result in
            switch result {
            case .err:
                XCTFail()
            
            case .ok(let chats):
                let reversed: [Chat] = mockChats.reversed()
                let info: [Chat] = chats
                XCTAssertEqual(reversed.map({ $0.id }), info.map({ $0.id }))
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
