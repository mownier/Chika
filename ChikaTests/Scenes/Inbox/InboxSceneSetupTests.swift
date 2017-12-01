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
    // item is nil
    func testFormatA() {
        var item: InboxSceneItem?
        var cell: InboxSceneCell?
        let theme = InboxScene.Theme()
        let setup = InboxScene.Setup()
        
        item = InboxSceneItem(chat: Chat())
        cell = nil
        var ok = setup.format(cell: cell, theme: theme, item: item, isLast: false)
        XCTAssertFalse(ok)
        
        item = nil
        cell = InboxSceneCell()
        ok = setup.format(cell: cell, theme: theme, item: item, isLast: false)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: height function should return 0 given
    // that cell or item is nil
    func testHeightA() {
        var item: InboxSceneItem?
        var cell: InboxSceneCell?
        let theme = InboxScene.Theme()
        let setup = InboxScene.Setup()
        
        item = InboxSceneItem(chat: Chat())
        cell = nil
        var height = setup.height(for: cell, theme: theme, item: item, isLast: false)
        XCTAssertEqual(height, 0)
        
        item = nil
        cell = InboxSceneCell()
        height = setup.height(for: cell, theme: theme, item: item, isLast: false)
        XCTAssertEqual(height, 0)
    }
}
