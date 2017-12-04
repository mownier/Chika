//
//  InboxRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/27/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol InboxRemoteListener: class {

    func listenForTypingStatus(callback: @escaping (Chat, [Person: Bool]) -> Void)
    func listenForOnlineStatus(callback: @escaping (Chat, [Person: Bool]) -> Void)
    func listenForRecentChat(callback: @escaping (Chat) -> Void)
}

class InboxRemoteListenerProvider: InboxRemoteListener {
    
    var meID: String
    var database: Database
    var chatsQuery: ChatsRemoteQuery
    var personsQuery: PersonsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.chatsQuery = chatsQuery
        self.personsQuery = personsQuery
    }
    
    func listenForTypingStatus(callback: @escaping (Chat, [Person: Bool]) -> Void) {
        guard !meID.isEmpty else {
            return
        }
        
        let rootRef = database.reference()
        
        rootRef.child("inbox:typing:status/\(meID)").queryOrderedByKey().observe(.childChanged) { [weak self] snapshot in
            self?.handleStatus(snapshot, callback)
        }
        
        rootRef.child("inbox:typing:status/\(meID)").queryOrderedByKey().observe(.childAdded) { [weak self] snapshot in
            self?.handleStatus(snapshot, callback)
        }
    }
    
    func listenForOnlineStatus(callback: @escaping (Chat, [Person: Bool]) -> Void) {
        guard !meID.isEmpty else {
            return
        }
        
        let rootRef = database.reference()
        
        rootRef.child("inbox:online:status/\(meID)").observe(.childChanged) { [weak self] snapshot in
            self?.handleStatus(snapshot, callback)
        }
        
        rootRef.child("inbox:online:status/\(meID)").observe(.childAdded) { [weak self] snapshot in
            self?.handleStatus(snapshot, callback)
        }
    }
    
    func listenForRecentChat(callback: @escaping (Chat) -> Void) {
        guard !meID.isEmpty else {
            return
        }
        
        let rootRef = database.reference()
        
        rootRef.child("person:inbox/\(meID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childChanged) { [weak self] snapshot in
            self?.handleRecentChat(snapshot, callback)
        }
        
        var isCallbackEnabled: Bool = false
        rootRef.child("person:inbox/\(meID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childAdded) { [weak self] snapshot in
            guard isCallbackEnabled else {
                isCallbackEnabled = true
                return
            }
            self?.handleRecentChat(snapshot, callback)
        }
    }
    
    private func handleRecentChat(_ snapshot: DataSnapshot, _ callback: @escaping (Chat) -> Void) {
        guard snapshot.exists() else {
            return
        }
        
        chatsQuery.getChats(for: [snapshot.key]) { chats in
            guard chats.count == 1 else {
                return
            }
            
            callback(chats[0])
        }
    }
    
    private func handleStatus(_ snapshot: DataSnapshot, _ callback: @escaping (Chat, [Person: Bool]) -> Void) {
        guard snapshot.exists() else {
            return
        }
        
        let personsQuery = self.personsQuery
        let meID = self.meID
        
        chatsQuery.getChats(for: [snapshot.key]) { chats in
            guard chats.count == 1 else {
                return
            }
            
            guard let value = snapshot.value as? [String: Bool] else {
                return
            }
    
            let personKeys: [String] = value.flatMap({ $0.key }).filter({ $0 != meID })
            
            personsQuery.getPersons(for: personKeys) { persons in
                guard persons.count == personKeys.count && persons.map({ $0.id }) == personKeys else {
                    return
                }
                
                var info: [Person: Bool] = [:]
                
                for person in persons {
                    info[person] = value[person.id]
                }
                
                callback(chats[0], info)
            }
        }
    }
}
