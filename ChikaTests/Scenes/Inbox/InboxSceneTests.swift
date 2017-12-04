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
        let cell = scene.tableView(scene.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNil(cell.reuseIdentifier)
    }
    
    // CONTEXT: heightForRow function should
    //   - return a non-zero height
    // GIVEN:
    //   - a single chat
    func testHeightForRowA() {
        let scene = InboxScene()
        let worker = InboxSceneWorkerMock()
        var chat = Chat()
        chat.id = "chat:1"
        chat.title = "Title 1"
        chat.recent.content = "Hello World!"
        scene.data.append(list: [chat])
        scene.worker = worker
        let view = scene.view
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        let height = scene.tableView(scene.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(height != 0)
    }
    
    // CONTEXT: workerDidFetch function should
    //   - remove all chats in data
    //   - append the new Chat array into data
    //   - tableView calls the reloadData
    // GIVEN:
    //   - an initial Chat array appended to data
    //   - a tableView mock
    func testWorkerDidFetchA() {
        let worker = InboxSceneWorkerMock()
        let scene = InboxScene()
        let tableView = TableViewMock()
        var chat1 = Chat()
        var chat2 = Chat()
        var chat3 = Chat()
        var chat4 = Chat()
        chat1.id = "chat:1"
        chat2.id = "chat:2"
        chat3.id = "chat:3"
        chat4.id = "chat:4"
        let initialChats = [chat1, chat2]
        let outputChats = [chat3, chat4]
        scene.data.append(list: initialChats)
        scene.tableView = tableView
        scene.worker = worker
        scene.workerDidFetch(chats: outputChats)
        XCTAssertEqual(scene.data.itemCount, 2)
        XCTAssertEqual(scene.data.item(at: 0)?.chat.id, "chat:3")
        XCTAssertEqual(scene.data.item(at: 1)?.chat.id, "chat:4")
        XCTAssertTrue(tableView.isReloadDataCalled)
    }
    
    // CONTEXT: workerDidFetchWithError function should
    //   - tableView calls the reloadData
    func testWorkerDidFetchWithErrorA() {
        let scene = InboxScene()
        let tableView = TableViewMock()
        let error = ServiceError("inbox is empty")
        scene.tableView = tableView
        scene.workerDidFetchWithError(error)
        XCTAssertTrue(tableView.isReloadDataCalled)
    }
}
