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
        data.chats = []
        XCTAssertTrue(data.chats.isEmpty)
        
        var chat = Chat()
        chat.id = "chatID"
        let list = [chat]
        
        data.append(list: list)
        
        XCTAssertFalse(data.chats.isEmpty)
        XCTAssertEqual(data.chats.count, 1)
        XCTAssertEqual(data.chats[0].id, "chatID")
    }
}
