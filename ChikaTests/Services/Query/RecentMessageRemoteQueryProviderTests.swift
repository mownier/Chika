//
//  RecentMessageRemoteQueryProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RecentMessageRemoteQueryProviderTests: XCTestCase {
    
    // CONTEXT: getRecentMessage function should return nil
    // given that chatID is empty
    func testGetRecentMessageA() {
        let exp = expectation(description: "testGetRecentMessageA")
        let query = RecentMessageRemoteQueryProvider()
        let chatID = ""
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return nil
    // given that chatID is not empty but the snapshot's value
    // is not a [String : Any] type
    func testGetRecentMessageB() {
        let exp = expectation(description: "testGetRecentMessageA")
        let database = FirebaseDatabaseMock()
        let query = RecentMessageRemoteQueryProvider(database: database)
        let chatID = "chat:1"
        database.mockReference.query.snapshotValue = "not a [String : Any] type"
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return nil
    // given that chatID is not empty, the snapshot's value
    // is of type [String : Any] but empty
    func testGetRecentMessageC() {
        let exp = expectation(description: "testGetRecentMessageC")
        let database = FirebaseDatabaseMock()
        let query = RecentMessageRemoteQueryProvider(database: database)
        let chatID = "chat:1"
        database.mockReference.query.snapshotValue = [String : Any]()
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return nil
    // givent that chatID is not empty, the snapshot's value
    // is of type [String : Any] but has contents more than 1
    func testGetRecentMessageD() {
        let exp = expectation(description: "testGetRecentMessageC")
        let database = FirebaseDatabaseMock()
        let query = RecentMessageRemoteQueryProvider(database: database)
        let chatID = "chat:1"
        let value: [String : Any] = ["1" : 1, "2" : 2]
        database.mockReference.query.snapshotValue = value
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return nil
    // GIVEN:
    //   - chatID is not empty
    //   - snapshot's value is of type [String : Any]
    //   - snapshot's value has only one content
    // BUT:
    //   - messagesQuery returns messages whose count is not
    //     equal to the keys, which is passed to messagseQuery,
    //     count
    func testGetRecentMessageE() {
        let exp = expectation(description: "testGetRecentMessageC")
        let database = FirebaseDatabaseMock()
        let messagesQuery = MessagesRemoteQueryMock()
        let query = RecentMessageRemoteQueryProvider(database: database, messagesQuery: messagesQuery)
        let chatID = "chat:1"
        let value: [String : Any] = ["1" : 1]
        messagesQuery.mockMessages = [Message(), Message(), Message()]
        database.mockReference.query.snapshotValue = value
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return nil
    // GIVEN:
    //   - chatID is not empty
    //   - snapshot's value is of type [String : Any]
    //   - snapshot's value has only one content
    // BUT:
    //   - messagesQuery returns messages whose ids are not equal
    //     to the keys passed to messagseQuery
    func testGetRecentMessageF() {
        let exp = expectation(description: "testGetRecentMessageF")
        let database = FirebaseDatabaseMock()
        let messagesQuery = MessagesRemoteQueryMock()
        let query = RecentMessageRemoteQueryProvider(database: database, messagesQuery: messagesQuery)
        let chatID = "chat:1"
        let value: [String : Any] = ["1" : 1]
        var message = Message()
        message.id = "2"
        messagesQuery.mockMessages = [message]
        database.mockReference.query.snapshotValue = value
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getRecentMessage function should return a message
    // GIVEN:
    //   - chatID is not empty
    //   - snapshot's value is of type [String : Any]
    //   - snapshot's value has only one content
    //   - messagesQuery returns messages whose ids are equal
    //     to the keys passed to messagseQuery
    func testGetRecentMessageG() {
        let exp = expectation(description: "testGetRecentMessageG")
        let database = FirebaseDatabaseMock()
        let messagesQuery = MessagesRemoteQueryMock()
        let query = RecentMessageRemoteQueryProvider(database: database, messagesQuery: messagesQuery)
        let chatID = "chat:1"
        let value: [String : Any] = ["1" : 1]
        var message = Message()
        message.id = "1"
        messagesQuery.mockMessages = [message]
        database.mockReference.query.snapshotValue = value
        query.getRecentMessage(for: chatID) { message in
            XCTAssertNotNil(message)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
