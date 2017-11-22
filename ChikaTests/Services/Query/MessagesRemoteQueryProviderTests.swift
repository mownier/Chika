//
//  MessagesRemoteQueryProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class MessagesRemoteQueryProviderTests: XCTestCase {
    
    // CONTEXT: getMessages function should return an empty array
    // GIVEN:
    //   - keys is empty
    func testGetMessagesA() {
        let exp = expectation(description: "testGetMessagesA")
        let query = MessagesRemoteQueryProvider()
        let keys = [String]()
        query.getMessages(for: keys) { messages in
            XCTAssertTrue(messages.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getMessages function should
    //   - return an array of message whose ids are not equal
    //     to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is not of type [String : Any]
    func testGetMessagesB() {
        let exp = expectation(description: "testGetMessagesB")
        let database = FirebaseDatabaseMock()
        let personsQuery = PersonsRemoteQueryMock()
        let query = MessagesRemoteQueryProvider(database: database, personsQuery: personsQuery)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "author": "person:1"]
        let snapshot2: Any = 1
        var person1 = Person()
        var person2 = Person()
        person1.id = "person:1"
        person2.id = "person:2"
        personsQuery.mockPersons = [[person1], [person2]]
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getMessages(for: keys) { messages in
            XCTAssertEqual(messages.count, 1)
            XCTAssertNotEqual(keys, messages.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getMessages function should
    //   - return an array of messages whose ids are equal
    //     to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is of type [String : Any]
    func testGetMessagesC() {
        let exp = expectation(description: "testGetMessagesC")
        let database = FirebaseDatabaseMock()
        let personsQuery = PersonsRemoteQueryMock()
        let query = MessagesRemoteQueryProvider(database: database, personsQuery: personsQuery)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "author": "person:1", "content": "Hello"]
        let snapshot2: [String : Any] = ["id" : "key:2", "author": "person:2", "content": "Hi"]
        var person1 = Person()
        var person2 = Person()
        person1.id = "person:1"
        person2.id = "person:2"
        personsQuery.mockPersons = [[person1], [person2]]
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getMessages(for: keys) { messages in
            XCTAssertEqual(messages.count, 2)
            XCTAssertEqual(keys, messages.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getMessages function should
    //   - return an array of messages whose ids are not
    //     equal to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is of type [String : Any]
    //   - sort sorts incorrectly
    func testGetMessagesD() {
        let exp = expectation(description: "testGetMessagesD")
        let sort = MessagesSortMock()
        let database = FirebaseDatabaseMock()
        let personsQuery = PersonsRemoteQueryMock()
        let query = MessagesRemoteQueryProvider(database: database, personsQuery: personsQuery, sort: sort)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "author": "person:1"]
        let snapshot2: [String : Any] = ["id" : "key:2", "author": "person:2"]
        var message1 = Message()
        var message2 = Message()
        var person1 = Person()
        var person2 = Person()
        person1.id = "person:1"
        person2.id = "person:2"
        personsQuery.mockPersons = [[person1], [person2]]
        message1.id = "key:1"
        message2.id = "key:2"
        sort.mockMessages = [message2, message1]
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getMessages(for: keys) { messages in
            XCTAssertEqual(messages.count, 2)
            XCTAssertNotEqual(keys, messages.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getMessages function should
    //   - return an array of message whose ids are not equal
    //     to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is not of type [String : Any]
    //   - personQuery returns an empty array of persons for key:1
    func testGetMessagesE() {
        let exp = expectation(description: "testGetMessagesE")
        let database = FirebaseDatabaseMock()
        let personsQuery = PersonsRemoteQueryMock()
        let query = MessagesRemoteQueryProvider(database: database, personsQuery: personsQuery)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "author": "person:1"]
        let snapshot2: [String : Any] = ["id" : "key:2", "author": "person:2"]
        var person2 = Person()
        person2.id = "person:2"
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        personsQuery.mockPersons = [[], [person2]]
        query.getMessages(for: keys) { messages in
            XCTAssertEqual(messages.count, 1)
            XCTAssertNotEqual(keys, messages.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getMessages function should
    //   - return an empty array of message
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is not of type [String : Any]
    //   - key:1 and key:2 snapshot values have no key "author"
    //   - personQuery returns an empty array of persons for key:1
    func testGetMessagesF() {
        let exp = expectation(description: "testGetMessagesE")
        let database = FirebaseDatabaseMock()
        let personsQuery = PersonsRemoteQueryMock()
        let query = MessagesRemoteQueryProvider(database: database, personsQuery: personsQuery)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1"]
        let snapshot2: [String : Any] = ["id" : "key:2"]
        var person1 = Person()
        var person2 = Person()
        person1.id = "person:2"
        person2.id = "person:2"
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        personsQuery.mockPersons = [[person1], [person2]]
        query.getMessages(for: keys) { messages in
            XCTAssertEqual(messages.count, 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
