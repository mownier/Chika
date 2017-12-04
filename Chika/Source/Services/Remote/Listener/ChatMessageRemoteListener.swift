//
//  ChatMessageRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/27/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase

protocol ChatMessageRemoteListener: class {

    func listen(for chatID: String, callback: @escaping (Message) -> Void) -> Bool
    func unlisten(for chatID: String) -> Bool
}

class ChatMessageRemoteListenerProvider: ChatMessageRemoteListener {
    
    var handles: [String: UInt]
    var database: Database
    var messagesQuery: MessagesRemoteQuery
    var meID: String
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), messagesQuery: MessagesRemoteQuery = MessagesRemoteQueryProvider()) {
        self.handles = [:]
        self.meID = meID
        self.database = database
        self.messagesQuery = messagesQuery
    }
    
    func listen(for chatID: String, callback: @escaping (Message) -> Void) -> Bool {
        guard !chatID.isEmpty, handles[chatID] == nil else {
            return false
        }
        
        let rootRef = database.reference()
        let messagesQuery = self.messagesQuery
        let meID = self.meID
        var isCallbackEnabled = false
        
        let handle = rootRef.child("chat:messages/\(chatID)").queryOrdered(byChild: "created_on").queryLimited(toLast: 1).observe(.childAdded) { snapshot in
            guard isCallbackEnabled, snapshot.exists() else {
                isCallbackEnabled = true
                return
            }
            
            messagesQuery.getMessages(for: [snapshot.key]) { messages in
                guard messages.count == 1, messages[0].author.id != meID else {
                    return
                }

                callback(messages[0])
            }
        }
        
        handles[chatID] = handle
        return true
    }
    
    func unlisten(for chatID: String) -> Bool {
        guard !chatID.isEmpty, handles[chatID] == nil else {
            return false
        }
        
        handles.removeValue(forKey: chatID)
        return true
    }
}
