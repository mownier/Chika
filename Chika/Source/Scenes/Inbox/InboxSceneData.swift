//
//  InboxSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation
import FirebaseAuth

enum InboxSceneDataUpdateResult {
    
    case new(Bool)
    case existing(Bool)
    
    var isYours: Bool {
        switch self {
        case .new(let isYours),
             .existing(let isYours):
            return isYours
        }
    }
}

protocol InboxSceneData: class {

    var itemCount: Int { get }
    var unreadChatCount: Int { get }
    
    func item(at index: Int) -> InboxSceneItem?
    func append(list: [Chat])
    func update(_ chat: Chat) -> InboxSceneDataUpdateResult
    func updateMessageCount(for item: InboxSceneItem)
    func updateActiveStatus(for participantID: String, isActive: Bool) -> [Int]
    func updateTypingStatus(for chatID: String, participantID: String, isTyping: Bool) -> Int?
    func updateTitle(for chatID: String, title: String) -> Int?
    func removeAll()
    func item(for chat: Chat) -> InboxSceneItem?
}

extension InboxScene {
    
    class Data: InboxSceneData {
        
        var meID: String
        var items: [InboxSceneItem]
        
        var itemCount: Int {
            return items.count
        }
        
        var unreadChatCount: Int {
            return items.reduce(into: 0) { result, item in
                if item.unreadMessageCount > 0 {
                    result += 1
                }
            }
        }
        
        init(meID: String = Auth.auth().currentUser?.uid ?? "") {
            self.items = []
            self.meID = meID
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
        
        func update(_ newChat: Chat) -> InboxSceneDataUpdateResult {
            guard let index = items.index(where: { $0.chat.id == newChat.id }) else {
                var item = InboxSceneItem(chat: newChat)
                if !meID.isEmpty, !newChat.recent.author.id.isEmpty, newChat.recent.author.id != meID {
                    item.unreadMessageCount += 1
                }
                items.insert(item, at: 0)
                return .new(!meID.isEmpty && meID == newChat.recent.author.id)
            }
            
            items[index].chat = newChat
            if !meID.isEmpty, !newChat.recent.author.id.isEmpty, newChat.recent.author.id != meID {
                items[index].unreadMessageCount += 1
            }
            items.sort(by: { $0.chat.recent.date.timeIntervalSince1970 > $1.chat.recent.date.timeIntervalSince1970 })
            return .existing(!meID.isEmpty && meID == newChat.recent.author.id)
        }
        
        func updateMessageCount(for item: InboxSceneItem) {
            guard let index = items.index(where: { $0.chat.id == item.chat.id }) else {
                return
            }
            
            items[index].unreadMessageCount = item.unreadMessageCount
        }
        
        func updateActiveStatus(for participantID: String, isActive: Bool) -> [Int] {
            let indexes: [Int] = items.enumerated().filter({ $1.chat.participants.map({ $0.id }).contains(participantID) }).map({ $0.offset })
            
            guard !indexes.isEmpty else {
                return []
            }
            
            for index in indexes {
                if isActive {
                    items[index].active[participantID] = isActive

                } else {
                    items[index].active.removeValue(forKey: participantID)
                }

                items[index].isSomeoneOnline = !items[index].active.isEmpty
            }

            return indexes
        }
        
        func updateTypingStatus(for chatID: String, participantID: String, isTyping: Bool) -> Int? {
            guard let index = items.index(where: { $0.chat.id == chatID }) else {
                return nil
            }
            
            guard let participantIndex = items[index].chat.participants.index(where: { $0.id == participantID }) else {
                return nil
            }
            
            let participant = items[index].chat.participants[participantIndex]
            
            if isTyping {
                items[index].typing[participantID] = participant.displayName
                
            } else {
                items[index].typing.removeValue(forKey: participant.id)
            }
            
            guard !items[index].typing.isEmpty else {
                items[index].typingText = ""
                return index
            }
            
            var typingText = " are typing..."
            let count = items[index].typing.count
            if count == 1 {
                typingText = " is typing..."
            }
            
            var personText = ""
            var i = 0
            for (_, value) in items[index].typing {
                if i != 0 && i == count - 1 {
                    personText.append(" and ")
                    
                } else if i > 0 {
                    personText.append(", ")
                }
                personText.append(value)
                i += 1
            }
            
            items[index].typingText = "\(personText) \(typingText)"
            return index
        }
        
        func updateTitle(for chatID: String, title: String) -> Int? {
            guard let index = items.index(where: { $0.chat.id == chatID }) else {
                return nil
            }
            
            items[index].chat.title = title
            return index
        }
        
        func item(for chat: Chat) -> InboxSceneItem? {
            guard let index = items.index(where: { $0.chat.id == chat.id }) else {
                return nil
            }
            
            return items[index]
        }
    }
}
