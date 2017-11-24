//
//  ChatMessagesRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatMessagesRemoteQuery: class {
    
    func getMessages(for chatID: String, offset: String, limit: UInt, completion: @escaping ([Message]) -> Void)
}

class ChatMessagesRemoteQueryProvider: ChatMessagesRemoteQuery {

    var messagesQuery: MessagesRemoteQuery
    var database: Database
    var path: String
    var sort: MessagesSort
    
    init(database: Database, path: String, messagesQuery: MessagesRemoteQuery, sort: MessagesSort) {
        self.database = database
        self.path = path
        self.messagesQuery = messagesQuery
        self.sort = sort
    }
    
    convenience init() {
        let database = Database.database()
        let path = "chat:messages"
        let messagesQuery = MessagesRemoteQueryProvider()
        let sort = MessagesSortProvider()
        self.init(database: database, path: path, messagesQuery: messagesQuery, sort: sort)
    }
    
    func getMessages(for chatID: String, offset: String, limit: UInt, completion: @escaping ([Message]) -> Void) {
        guard !chatID.isEmpty else {
            completion([])
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("\(path)/\(chatID)")
        let messagesQuery = self.messagesQuery
        var query = ref.queryOrdered(byChild: "created_on")
        
        if offset.isEmpty {
            query = query.queryEnding(atValue: offset)
        }
        
        if limit > 0 {
            query = query.queryLimited(toLast: limit + 1)
        }
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard let info = snapshot.value as? [String : Any] else {
                completion([])
                return
            }
            
            let messageKeys: [String] = info.flatMap({ $0.key })
            
            messagesQuery.getMessages(for: messageKeys) { messages in
                var messages = messages
                if messages.count == Int(limit + 1) {
                    let _ = messages.removeFirst()
                }
                completion(messages)
            }
        }
    }
}
