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
    func update(_ chat: Chat)
    func removeAll()
}

extension InboxScene {
    
    class Data: InboxSceneData {
        
        var chats: [Chat]
        
        init() {
            chats = []
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
        
        func removeAll() {
            chats.removeAll()
        }
        
        func chatCount(in section: Int) -> Int {
            return chats.count
        }
        
        func update(_ newChat: Chat) {
            guard let index = chats.index(where: { $0.id == newChat.id }) else {
                chats.insert(newChat, at: 0)
                return
            }
            
            chats[index] = newChat
            chats.sort(by: { $0.recent.date.timeIntervalSince1970 > $1.recent.date.timeIntervalSince1970 })
        }
    }
}
