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

    func listen(callback: @escaping (Message) -> Void)
}

class ChatMessageRemoteListenerProvider: ChatMessageRemoteListener {
    
    var chatID: String
    var database: Database
    var messagesQuery: MessagesRemoteQuery
    var meID: String
    
    init(chatID: String, meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), messagesQuery: MessagesRemoteQuery = MessagesRemoteQueryProvider()) {
        self.chatID = chatID
        self.meID = meID
        self.database = database
        self.messagesQuery = messagesQuery
    }
    
    func listen(callback: @escaping (Message) -> Void) {
        guard !chatID.isEmpty else {
            return
        }
        
        let rootRef = database.reference()
        let messagesQuery = self.messagesQuery
        let meID = self.meID
        var isCallbackEnabled = false
        
        rootRef.child("chat:messages/\(chatID)").queryOrdered(byChild: "created_on").queryLimited(toLast: 1).observe(.childAdded) { snapshot in
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
    }
}
