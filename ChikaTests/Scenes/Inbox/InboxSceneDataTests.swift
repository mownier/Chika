//
//  InboxSceneDataTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxSceneDataTests: XCTestCase {
    
    // CONTEXT: append function should append list of chats
    func testAppendA() {
        let data = InboxScene.Data()
        data.items = []
        XCTAssertTrue(data.items.isEmpty)
        
        var chat = Chat()
        chat.id = "chatID"
        let list = [chat]
        
        data.append(list: list)
        
        XCTAssertFalse(data.items.isEmpty)
        XCTAssertEqual(data.items.count, 1)
        XCTAssertEqual(data.items[0].chat.id, "chatID")
    }
}
