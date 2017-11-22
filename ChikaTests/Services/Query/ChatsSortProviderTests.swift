//
//  ChatsSortProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class ChatsSortProviderTests: XCTestCase {
    
    // CONTEXT: sortByKeys function should fail to sort
    // the array given that chat ids are not found in keys
    func testSortByKeysA() {
        let sort = ChatsSortProvider()
        let keys = ["key:1", "key:2", "key:3"]
        var chat1 = Chat()
        var chat2 = Chat()
        chat1.id = "key:4"
        chat2.id = "key:5"
        var chats = [chat1, chat2]
        let copy = chats
        sort.by(keys, &chats)
        XCTAssertEqual(copy.map({ $0.id }), chats.map({ $0.id }))
    }
    
    // CONTEXT: sortByKeys function should fail to sort
    // the chats according to the passed keys
    func testSortByKeysB() {
        let sort = ChatsSortProvider()
        let keys = ["key:1", "key:2", "key:3"]
        var chat1 = Chat()
        var chat2 = Chat()
        var chat3 = Chat()
        chat1.id = "key:1"
        chat2.id = "key:2"
        chat3.id = "key:3"
        var chats = [chat2, chat3, chat1]
        let copy = chats
        sort.by(keys, &chats)
        XCTAssertNotEqual(copy.map({ $0.id }), chats.map({ $0.id }))
        XCTAssertEqual(keys, chats.map({ $0.id }))
    }
}
