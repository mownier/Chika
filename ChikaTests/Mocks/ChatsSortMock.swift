//
//  ChatsSortMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class ChatsSortMock: ChatsSort {

    var mockChats: [Chat] = []
    
    func by(_ keys: [String], _ chats: inout [Chat]) {
        chats = mockChats
    }
}
