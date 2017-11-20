//
//  InboxSceneSetupTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxSceneSetupTests: XCTestCase {
    
    // CONTEXT: format function should return false given
    // that cell is not an instance of InboxSceneCell or
    // chat is nil
    func testFormatA() {
        var chat: Chat?
        var cell: InboxSceneCell?
        let theme = InboxScene.Theme()
        let setup = InboxScene.Setup()
        
        chat = Chat()
        cell = nil
        var ok = setup.format(cell: cell, theme: theme, chat: chat)
        XCTAssertFalse(ok)
        
        chat = nil
        cell = InboxSceneCell()
        ok = setup.format(cell: cell, theme: theme, chat: chat)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: height function should return 0 given
    // that cell or chat is nil
    func testHeightA() {
        var chat: Chat?
        var cell: InboxSceneCell?
        let theme = InboxScene.Theme()
        let setup = InboxScene.Setup()
        
        chat = Chat()
        cell = nil
        var height = setup.height(for: cell, theme: theme, chat: chat)
        XCTAssertEqual(height, 0)
        
        chat = nil
        cell = InboxSceneCell()
        height = setup.height(for: cell, theme: theme, chat: chat)
        XCTAssertEqual(height, 0)
    }
}
