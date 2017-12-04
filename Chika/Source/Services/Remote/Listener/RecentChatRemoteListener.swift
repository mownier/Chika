//
//  RecentChatRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/27/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol RecentChatRemoteListener: class {
    
    func listen(callback: @escaping (Chat) -> Void) -> Bool
    func unlisten() -> Bool
}

class RecentChatRemoteListenerProvider: RecentChatRemoteListener {
    
    var meID: String
    var database: Database
    var chatsQuery: ChatsRemoteQuery
    var personsQuery: PersonsRemoteQuery
    var addedHandle: UInt?
    var changedHandle: UInt?
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.chatsQuery = chatsQuery
        self.personsQuery = personsQuery
    }
    
    func unlisten() -> Bool {
        guard !meID.isEmpty else {
            return false
        }
        
        return true
    }
    
    func listen(callback: @escaping (Chat) -> Void) -> Bool {
        guard !meID.isEmpty else {
            return false
        }
        
        let rootRef = database.reference()
        
        changedHandle = rootRef.child("person:inbox/\(meID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childChanged) { [weak self] snapshot in
            self?.handleRecentChat(snapshot, callback)
        }
        
        var isCallbackEnabled: Bool = false
        addedHandle = rootRef.child("person:inbox/\(meID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childAdded) { [weak self] snapshot in
            guard isCallbackEnabled else {
                isCallbackEnabled = true
                return
            }
            self?.handleRecentChat(snapshot, callback)
        }
        
        return true
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
}
