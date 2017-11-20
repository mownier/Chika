//
//  InboxSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

protocol InboxSceneData: class {

    func chatCount(in section: Int) -> Int
    func chat(at indexPath: IndexPath) -> Chat?
    func append(list: [Chat])
}

extension InboxScene {
    
    class Data: InboxSceneData {
        
        var chats: [Chat]
        
        init() {
            chats = []
            
            // TODO: Delete this
            var chat = Chat()
            chat.title = "Chat 1"
            chat.recent.content = "Chat Message Content 1"
            chats.append(chat)
            
            chat.title = "Chat 2"
            chat.recent.content = "Chat Message Content 2"
            chats.append(chat)
        }
        
        func chat(at indexPath: IndexPath) -> Chat? {
            guard !indexPath.isEmpty, indexPath.row >= 0, indexPath.row < chats.count else {
                return nil
            }
            
            return chats[indexPath.row]
        }
        
        func append(list: [Chat]) {
            chats.append(contentsOf: list)
        }
        
        func chatCount(in section: Int) -> Int {
            return chats.count
        }
    }
}
