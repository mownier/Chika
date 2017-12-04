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
        let recentChat = RecentChatRemoteListenerMock()
        let presence = PresenceRemoteListenerMock()
        let typingStatus = TypingStatusRemoteListenerMock()
        let listener = InboxScene.Worker.Listener(recentChat: recentChat, presence: presence, typingStatus: typingStatus)
        let worker = InboxScene.Worker(meID: personID, service: service, listener: listener)
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
        let recentChat = RecentChatRemoteListenerMock()
        let presence = PresenceRemoteListenerMock()
        let typingStatus = TypingStatusRemoteListenerMock()
        let listener = InboxScene.Worker.Listener(recentChat: recentChat, presence: presence, typingStatus: typingStatus)
        let worker = InboxScene.Worker(meID: personID, service: service, listener: listener)
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
