//
//  MessagesSortMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class MessagesSortMock: MessagesSort {

    var mockMessages: [Message] = []
    
    func by(_ keys: [String], _ messages: inout [Message]) {
        messages = mockMessages
    }
}
