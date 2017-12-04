//
//  InboxSceneItem.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/1/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct InboxSceneItem {
    
    var chat: Chat
    var isSomeoneOnline: Bool
    var typingText: String
    var unreadMessageCount: UInt
    var active: [String: Bool]
    var typing: [String: String]
    
    init(chat: Chat) {
        self.chat = chat
        self.isSomeoneOnline = false
        self.unreadMessageCount = 0
        self.typingText = ""
        self.active = [:]
        self.typing = [:]
    }
}
