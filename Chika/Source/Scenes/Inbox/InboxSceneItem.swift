//
//  InboxSceneItem.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/1/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct InboxSceneItem {
    
    var chat: Chat
    var isOnline: Bool
    var unreadMessageCount: UInt
    
    init(chat: Chat) {
        self.chat = chat
        self.isOnline = false
        self.unreadMessageCount = 0
    }
}
