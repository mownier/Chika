//
//  ConvoSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol ConvoSceneData: class {
    
    func messageCount(in section: Int) -> Int
    func message(at indexPath: IndexPath) -> Message?
    func pushFront(list: [Message])
    func pushRear(list: [Message])
    func removeAll()
    func update(_ message: Message)
    func contact(withChat: Chat) -> Contact?
}

extension ConvoScene {
    
    class Data: ConvoSceneData {
        
        var meID: String
        var messages: [Message]
        
        init(meID: String = Auth.auth().currentUser?.uid ?? "") {
            self.meID = meID
            self.messages = []
        }
        
        func messageCount(in section: Int) -> Int {
            return messages.count
        }
        
        func message(at indexPath: IndexPath) -> Message? {
            guard !indexPath.isEmpty, indexPath.row >= 0, indexPath.row < messages.count else {
                return nil
            }
            
            return messages[indexPath.row]
        }
        
        func pushFront(list: [Message]) {
            messages.insert(contentsOf: list, at: 0)
        }
        
        func pushRear(list: [Message]) {
            messages.append(contentsOf: list)
        }
        
        func removeAll() {
            messages.removeAll()
        }
        
        func update(_ newMessage: Message) {
            guard let index = messages.index(where: { $0.id == newMessage.id }) else {
                messages.append(newMessage)
                return
            }
            
            messages[index] = newMessage
            messages.sort(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
        }
        
        func contact(withChat chat: Chat) -> Contact? {
            guard chat.creator.isEmpty, chat.participants.count == 2,
                let person = chat.participants.filter({ $0.id != meID }).first else {
                    return nil
            }
    
            var contact = Contact()
            contact.chat = chat
            contact.person = person
            
            return contact
        }
    }
}
