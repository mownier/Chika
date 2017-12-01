//
//  InboxRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/27/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol InboxRemoteListener: class {

    func listen(callback: @escaping (Chat) -> Void)
}

class InboxRemoteListenerProvider: InboxRemoteListener {
    
    var personID: String
    var database: Database
    var chatsQuery: ChatsRemoteQuery
    
    init(personID: String, database: Database = Database.database(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider()) {
        self.personID = personID
        self.database = database
        self.chatsQuery = chatsQuery
    }
    
    func listen(callback: @escaping (Chat) -> Void) {
        guard !personID.isEmpty else {
            return
        }
        
        let rootRef = database.reference()
        var isCallbackEnabled: Bool = false
        rootRef.child("person:inbox/\(personID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childChanged) { [weak self] snapshot in
            self?.handleSnapshot(snapshot, callback)
        }
        
        rootRef.child("person:inbox/\(personID)").queryOrdered(byChild: "updated_on").queryLimited(toLast: 1).observe(.childAdded) { [weak self] snapshot in
            guard isCallbackEnabled else {
                isCallbackEnabled = true
                return
            }
            self?.handleSnapshot(snapshot, callback)
        }
    }
    
    private func handleSnapshot(_ snapshot: DataSnapshot, _ callback: @escaping (Chat) -> Void) {
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
