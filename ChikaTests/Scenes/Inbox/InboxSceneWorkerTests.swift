//
//  InboxSceneWorkerTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxSceneWorkerTests: XCTestCase {
    
    // CONTEXT: Constructor should
    //   - have an empty personID
    // GIVEN:
    //   - user is nil
    func testInitA() {
        let worker = InboxScene.Worker(user: nil)
        XCTAssertTrue(worker.personID.isEmpty)
    }
    
    // CONTEXT: fetchInbox function should
    //   - call the workerDidFetchWithError function of
    //     output
    // GIVEN:
    //   - service returns a .err result
    //   - a non-empty personID
    //   - a ChatRemoteService mock
    func testFetchInboxA() {
        let personID = "person:1"
        let service = ChatRemoteServiceMock()
        let worker = InboxScene.Worker(personID: personID, service: service)
        let output = InboxSceneWorkerOutputMock()
        service.isForcedError = true
        worker.output = output
        worker.fetchInbox()
        XCTAssertNotNil(output.error)
        XCTAssertNil(output.chats)
    }
    
    // CONTEXT: fetchInbox function should
    //   - call the workerDidFetch function of output
    // GIVEN:
    //   - service returns an .ok result
    //   - a non-empty personID
    //   - a ChatRemoteService mock
    func testFetchInboxB() {
        let personID = "person:1"
        let service = ChatRemoteServiceMock()
        let worker = InboxScene.Worker(personID: personID, service: service)
        let output = InboxSceneWorkerOutputMock()
        var chat = Chat()
        chat.id = "chat:1"
        let mockChats = [chat]
        service.chats = mockChats
        service.isForcedError = false
        worker.output = output
        worker.fetchInbox()
        XCTAssertNil(output.error)
        XCTAssertNotNil(output.chats)
        XCTAssertEqual(output.chats!.map({ $0.id }), mockChats.map({ $0.id }))
    }
}