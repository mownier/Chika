//
//  InboxSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxSceneTests: XCTestCase {
    
    // CONTEXT: Convenience Constructor should have an instance of InboxScene.Theme,
    // InboxScene.Data, InboxScene.Setup, and InboxScene.CellManager for
    // theme, data, setup and cellManager properties, respectively
    func testInitA() {
        let scene = InboxScene()
        XCTAssertTrue(scene.theme is InboxScene.Theme)
        XCTAssertTrue(scene.data is InboxScene.Data)
        XCTAssertTrue(scene.setup is InboxScene.Setup)
        XCTAssertTrue(scene.cellManager is InboxScene.CellManager)
        
        let decoder = NSCoder()
        let scene2 = InboxScene(coder: decoder)
        XCTAssertNotNil(scene2)
        XCTAssertTrue(scene2!.theme is InboxScene.Theme)
        XCTAssertTrue(scene2!.data is InboxScene.Data)
        XCTAssertTrue(scene2!.setup is InboxScene.Setup)
        XCTAssertTrue(scene2!.cellManager is InboxScene.CellManager)
    }
    
    // CONTEXT: cellForRow function should return an instance of
    // UITableViewCell with nil reuseIdentifier
    func testCellForRowA() {
        let scene = InboxScene()
        scene.setup = InboxSceneSetupMock()
        let cell = scene.tableView(scene.tableView, cellForRowAt: IndexPath())
        XCTAssertNil(cell.reuseIdentifier)
    }
}
