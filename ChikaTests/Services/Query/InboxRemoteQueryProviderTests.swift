//
//  InboxRemoteQueryProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxRemoteQueryProviderTests: XCTestCase {
    
    // CONTEXT: getInbox function should
    //   - return an empty array of Chat
    // GIVEN:
    //   - personID is empty
    func testGetInboxA() {
        let exp = expectation(description: "testGetInboxA")
        let query = InboxRemoteQueryProvider()
        let personID = ""
        query.getInbox(for: personID) { chats in
            XCTAssertTrue(chats.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getInbox function should
    //   - return an empty array of Chat
    // GIVEN:
    //   - personID is not empty
    //   - snapshot.value is not of type [String : Any]
    func testGetInboxB() {
        let exp = expectation(description: "testGetInboxB")
        let database = FirebaseDatabaseMock()
        let query = InboxRemoteQueryProvider(database: database)
        let personID = "person:1"
        let snapshot1: [String] = []
        database.mockReference.snapshotValues = [snapshot1]
        query.getInbox(for: personID) { chats in
            XCTAssertTrue(chats.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getInbox function should
    //   - return a Chat array that has 2 items
    // GIVEN:
    //   - personID is not empty
    //   - snapshot.value is of type [String : Any]
    //   - snapshot.value has 3 items
    //   - chatKeys are "chat:1", "chat:2", "chat:3"
    //   - chatsQuery did not found a Chat whose
    //     id is "chat:3"
    func testGetInboxC() {
        let exp = expectation(description: "testGetInboxC")
        let database = FirebaseDatabaseMock()
        let chatsQuery = ChatsRemoteQueryMock()
        let query = InboxRemoteQueryProvider(database: database, chatsQuery: chatsQuery)
        let personID = "person:1"
        let snapshot1: [String : Any] = ["chat:1" : true, "chat:2" : true, "chat:3" : true]
        var chat1 = Chat()
        var chat2 = Chat()
        chat1.id = "chat:1"
        chat2.id = "chat:2"
        database.mockReference.query.snapshotValue = snapshot1
        chatsQuery.mockChats = ["chat:1" : chat1, "chat:2" : chat2]
        query.getInbox(for: personID) { chats in
            XCTAssertEqual(chats.count, 2)
            XCTAssertTrue(chats.contains(where: { $0.id == "chat:1"}))
            XCTAssertTrue(chats.contains(where: { $0.id == "chat:2"}))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
