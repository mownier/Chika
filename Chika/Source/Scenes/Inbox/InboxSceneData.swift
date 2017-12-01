//
//  InboxSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

protocol InboxSceneData: class {

    var itemCount: Int { get }
    
    func item(at index: Int) -> InboxSceneItem?
    func append(list: [Chat])
    func update(_ chat: Chat)
    func updateMessageCount(for item: InboxSceneItem)
    func removeAll()
}

extension InboxScene {
    
    class Data: InboxSceneData {
        
        var items: [InboxSceneItem]
        
        var itemCount: Int {
            return items.count
        }
        
        init() {
            items = []
        }
        
        func item(at index: Int) -> InboxSceneItem? {
            guard index >= 0 && index < items.count else {
                return nil
            }
            
            return items[index]
        }
        
        func append(list: [Chat]) {
            items.append(contentsOf: list.map({ InboxSceneItem(chat: $0) }))
        }
        
        func removeAll() {
            items.removeAll()
        }
        
        func update(_ newChat: Chat) {
            guard let index = items.index(where: { $0.chat.id == newChat.id }) else {
                var item = InboxSceneItem(chat: newChat)
                item.unreadMessageCount += 1
                items.insert(item, at: 0)
                return
            }
            
            items[index].chat = newChat
            items[index].unreadMessageCount += 1
            items.sort(by: { $0.chat.recent.date.timeIntervalSince1970 > $1.chat.recent.date.timeIntervalSince1970 })
        }
        
        func updateMessageCount(for item: InboxSceneItem) {
            guard let index = items.index(where: { $0.chat.id == item.chat.id }) else {
                return
            }
            
            items[index].unreadMessageCount = item.unreadMessageCount
        }
    }
}
