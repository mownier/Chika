//
//  ChatTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class ChatTests: XCTestCase {
    
    // CONTEXT: hasOnlineParticipants function should return
    // false given that there are no participants
    func testHasOnlineParticipantsA() {
        var chat = Chat()
        chat.participants = []
        
        XCTAssertFalse(chat.hasOnlineParticipants)
    }
    
    // CONTEXT: hasOnlineParticipants function should return
    // false given that there are participants but they are
    // not online
    func testHasOnlineParticipantsB() {
        var chat = Chat()
        var person = Person()
        person.isOnline = false
        chat.participants.append(person)
        person.isOnline = false
        chat.participants.append(person)
        
        XCTAssertFalse(chat.hasOnlineParticipants)
    }
    
    // CONTEXT: hasOnlineParticipants function should return
    // true given that there are participants who are online
    func testHasOnlineParticipantsC() {
        var chat = Chat()
        var person = Person()
        person.isOnline = false
        chat.participants.append(person)
        person.isOnline = true
        chat.participants.append(person)
        person.isOnline = false
        chat.participants.append(person)
        person.isOnline = true
        chat.participants.append(person)
        
        XCTAssertTrue(chat.hasOnlineParticipants)
    }
}
