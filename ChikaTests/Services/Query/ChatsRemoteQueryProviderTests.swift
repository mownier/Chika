//
//  ChatsRemoteQueryProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class ChatsRemoteQueryProviderTests: XCTestCase {
    
    // CONTEXT: getChats function should
    //   - return an empty array
    // GIVEN:
    //   - keys is empty
    func testGetChatsA() {
        let query = ChatsRemoteQueryProvider()
        let keys = [String]()
        query.getChats(for: keys) { chats in
            XCTAssertTrue(chats.isEmpty)
        }
    }
    
    // CONTEXT: getChats function should
    //   - return an array of chats whose ids are
    //     not equal to the keys
    // GIVEN:
    //   - keys is not empty
    //   - two snapshot values are not of type [String : Any]
    func testGetChatsB() {
        let exp = expectation(description: "testGetChatsB")
        let personsQuery = PersonsRemoteQueryMock()
        let recentMessageQuery = RecentMessageRemoteQueryMock()
        let database = FirebaseDatabaseMock()
        let query = ChatsRemoteQueryProvider(database: database, personsQuery: personsQuery, recentMessageQuery: recentMessageQuery)
        let keys = ["chat:1", "chat:2", "chat:3"]
        let participants: [String: Any] = ["person:1" : true, "person:2" : true]
        let snapshot1: [String: Any] = ["id" : "chat:1", "title" : "Title 1", "creator" : "person:1", "participants": participants]
        let snapshot2: String = ""
        let snapshot3: Int = 0
        var person1 = Person()
        var person2 = Person()
        var recentMessage = Message()
        person1.id = "person:1"
        person2.id = "person:2"
        recentMessage.id = "message:1"
        personsQuery.mockPersons = [[person1, person2]]
        recentMessageQuery.mockMessages = [recentMessage]
        database.mockReference.snapshotValues = [snapshot1, snapshot2, snapshot3]
        query.getChats(for: keys) { chats in
            XCTAssertEqual(chats.count, 1)
            XCTAssertEqual(keys[0], chats[0].id)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getChats function should
    //   - return an array of chats whose ids are
    //     not equal to the keys
    // GIVEN:
    //   - keys is not empty
    //   - three snapshot values are of type [String : Any]
    //   - personsQuery returns empty persons for snapshot2 and snapshot3
    func testGetChatsC() {
        let exp = expectation(description: "testGetChatsC")
        let personsQuery = PersonsRemoteQueryMock()
        let recentMessageQuery = RecentMessageRemoteQueryMock()
        let database = FirebaseDatabaseMock()
        let query = ChatsRemoteQueryProvider(database: database, personsQuery: personsQuery, recentMessageQuery: recentMessageQuery)
        let keys = ["chat:1", "chat:2", "chat:3"]
        let participants1: [String: Any] = ["person:1" : true, "person:2" : true]
        let participants2: [String: Any] = ["person:1" : true, "person:3" : true]
        let participants3: [String: Any] = ["person:1" : true, "person:4" : true]
        let snapshot1: [String: Any] = ["id" : "chat:1", "participants": participants1]
        let snapshot2: [String: Any] = ["id" : "chat:2", "participants": participants2]
        let snapshot3: [String: Any] = ["id" : "chat:3", "participants": participants3]
        var person1 = Person()
        var person2 = Person()
        var person3 = Person()
        var person4 = Person()
        var recentMessage = Message()
        person1.id = "person:1"
        person2.id = "person:2"
        person3.id = "person:3"
        person4.id = "person:4"
        recentMessage.id = "message:1"
        let mockPersons1: [Person] = [person1, person2]
        let mockPersons2: [Person] = []
        let mockPersons3: [Person] = []
        personsQuery.mockPersons = [mockPersons1, mockPersons2, mockPersons3]
        recentMessageQuery.mockMessages = [recentMessage]
        database.mockReference.snapshotValues = [snapshot1, snapshot2, snapshot3]
        query.getChats(for: keys) { chats in
            XCTAssertEqual(chats.count, 1)
            XCTAssertEqual(keys[0], chats[0].id)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getChats function should
    //   - return an array of chats whose ids are
    //     not equal to the keys
    // GIVEN:
    //   - keys is not empty
    //   - three snapshot values are of type [String : Any]
    //   - personsQuery returns correct array of persons
    //     for all snapshots
    //   - recentMessageQuery returns a non-nil Message
    //     for all snapshots
    //   - sort has failed to sort the chats
    func testGetChatsE() {
        let exp = expectation(description: "testGetChatsE")
        let personsQuery = PersonsRemoteQueryMock()
        let recentMessageQuery = RecentMessageRemoteQueryMock()
        let sort = ChatsSortMock()
        let database = FirebaseDatabaseMock()
        let query = ChatsRemoteQueryProvider(database: database, personsQuery: personsQuery, recentMessageQuery: recentMessageQuery, sort: sort)
        let keys = ["chat:1", "chat:2", "chat:3"]
        let participants1: [String: Any] = ["person:1" : true, "person:2" : true]
        let participants2: [String: Any] = ["person:1" : true, "person:3" : true]
        let participants3: [String: Any] = ["person:1" : true, "person:4" : true]
        let snapshot1: [String: Any] = ["id" : "chat:1", "participants": participants1]
        let snapshot2: [String: Any] = ["id" : "chat:2", "participants": participants2]
        let snapshot3: [String: Any] = ["id" : "chat:3", "participants": participants3]
        var person1 = Person()
        var person2 = Person()
        var person3 = Person()
        var person4 = Person()
        var recentMessage1: Message? = Message()
        var recentMessage2: Message? = nil
        var recentMessage3: Message? = nil
        var chat1 = Chat()
        var chat2 = Chat()
        var chat3 = Chat()
        person1.id = "person:1"
        person2.id = "person:2"
        person3.id = "person:3"
        person4.id = "person:4"
        recentMessage1?.id = "message:1"
        recentMessage2?.id = "message:2"
        recentMessage3?.id = "message:3"
        chat1.id = "chat:1"
        chat2.id = "chat:2"
        chat3.id = "chat:3"
        let mockPersons1: [Person] = [person1, person2]
        let mockPersons2: [Person] = [person1, person3]
        let mockPersons3: [Person] = [person1, person4]
        let mockChats: [Chat] = [chat2, chat3, chat1]
        personsQuery.mockPersons = [mockPersons1, mockPersons2, mockPersons3]
        recentMessageQuery.mockMessages = [recentMessage1, recentMessage2, recentMessage3]
        database.mockReference.snapshotValues = [snapshot1, snapshot2, snapshot3]
        sort.mockChats = mockChats
        query.getChats(for: keys) { chats in
            XCTAssertEqual(chats.count, 3)
            XCTAssertNotEqual(keys, chats.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getChats function should
    //   - return an array of chats whose ids are equal to the keys
    // GIVEN:
    //   - keys is not empty
    //   - three snapshot values are of type [String : Any]
    //   - personsQuery returns correct array of persons
    //     for all snapshots
    //   - recentMessageQuery returns a non-nil Message
    //     for all snapshots
    //   - sort has sorted successfully
    func testGetChatsF() {
        let exp = expectation(description: "testGetChatsF")
        let personsQuery = PersonsRemoteQueryMock()
        let recentMessageQuery = RecentMessageRemoteQueryMock()
        let database = FirebaseDatabaseMock()
        let query = ChatsRemoteQueryProvider(database: database, personsQuery: personsQuery, recentMessageQuery: recentMessageQuery)
        let keys = ["chat:1", "chat:2", "chat:3"]
        let participants1: [String: Any] = ["person:1" : true, "person:2" : true]
        let participants2: [String: Any] = ["person:1" : true, "person:3" : true]
        let participants3: [String: Any] = ["person:1" : true, "person:4" : true]
        let snapshot1: [String: Any] = ["id" : "chat:1", "participants": participants1]
        let snapshot2: [String: Any] = ["id" : "chat:2", "participants": participants2]
        let snapshot3: [String: Any] = ["id" : "chat:3", "participants": participants3]
        var person1 = Person()
        var person2 = Person()
        var person3 = Person()
        var person4 = Person()
        var recentMessage1: Message? = Message()
        var recentMessage2: Message? = Message()
        var recentMessage3: Message? = Message()
        person1.id = "person:1"
        person2.id = "person:2"
        person3.id = "person:3"
        person4.id = "person:4"
        recentMessage1?.id = "message:1"
        recentMessage2?.id = "message:2"
        recentMessage3?.id = "message:3"
        let mockPersons1: [Person] = [person1, person2]
        let mockPersons2: [Person] = [person1, person3]
        let mockPersons3: [Person] = [person1, person4]
        personsQuery.mockPersons = [mockPersons1, mockPersons2, mockPersons3]
        recentMessageQuery.mockMessages = [recentMessage1, recentMessage2, recentMessage3]
        database.mockReference.snapshotValues = [snapshot1, snapshot2, snapshot3]
        query.getChats(for: keys) { chats in
            XCTAssertEqual(chats.count, 3)
            XCTAssertEqual(keys, chats.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
