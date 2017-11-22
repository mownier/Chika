//
//  MessagesSortProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class MessagesSortProviderTests: XCTestCase {
    
    // CONTEXT: sortByKeys function should fail to sort
    // the array given that message ids are not found in keys
    func testSortByKeysA() {
        let sort = MessagesSortProvider()
        let keys = ["key:1", "key:2", "key:3"]
        var message1 = Message()
        var message2 = Message()
        message1.id = "key:4"
        message2.id = "key:5"
        var messages = [message1, message2]
        let copy = messages
        sort.by(keys, &messages)
        XCTAssertEqual(copy.map({ $0.id }), messages.map({ $0.id }))
    }
    
    // CONTEXT: sortByKeys function should fail to sort
    // the messages according to the passed keys
    func testSortByKeysB() {
        let sort = MessagesSortProvider()
        let keys = ["key:1", "key:2", "key:3"]
        var message1 = Message()
        var message2 = Message()
        var message3 = Message()
        message1.id = "key:1"
        message2.id = "key:2"
        message3.id = "key:3"
        var messages = [message2, message3, message1]
        let copy = messages
        sort.by(keys, &messages)
        XCTAssertNotEqual(copy.map({ $0.id }), messages.map({ $0.id }))
        XCTAssertEqual(keys, messages.map({ $0.id }))
    }
}
