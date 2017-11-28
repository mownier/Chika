//
//  ChatMessagesRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatMessagesRemoteQuery: class {
    
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping ([Message], Double?) -> Void)
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
    
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping ([Message], Double?) -> Void) {
        guard !chatID.isEmpty else {
            completion([], nil)
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("\(path)/\(chatID)")
        let messagesQuery = self.messagesQuery
        var query = ref.queryOrdered(byChild: "created_on")
        
        if offset > 0 {
            query = query.queryEnding(atValue: offset)
        }
        
        if limit > 0 {
            query = query.queryLimited(toLast: limit + 1)
        }
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.hasChildren() else {
                completion([], nil)
                return
            }
            
            var messageKeys: [String] = []
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot, !child.key.isEmpty else {
                    continue
                }
                
                messageKeys.append(child.key)
            }
            
            messagesQuery.getMessages(for: messageKeys) { messages in
                var messages = messages
                var nextOffset: Double?
                if messages.count == Int(limit + 1) {
                    let msg = messages.removeFirst()
                    nextOffset = msg.date.timeIntervalSince1970 * 1000
                }
                completion(messages, nextOffset)
            }
        }
    }
}
