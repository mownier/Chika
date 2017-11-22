//
//  RecentMessageRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol RecentMessageRemoteQuery: class {
    
    func getRecentMessage(for chatID: String, completion: @escaping (Message?) -> Void)
}

class RecentMessageRemoteQueryProvider: RecentMessageRemoteQuery {

    var messagesQuery: MessagesRemoteQuery
    var database: Database
    var path: String
    
    init(database: Database = Database.database(), path: String = "chat:messages", messagesQuery: MessagesRemoteQuery = MessagesRemoteQueryProvider()) {
        self.database = database
        self.path = path
        self.messagesQuery = messagesQuery
    }
    
    func getRecentMessage(for chatID: String, completion: @escaping (Message?) -> Void) {
        guard !chatID.isEmpty else {
            completion(nil)
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("\(path)/\(chatID)")
        let messagesQuery = self.messagesQuery
        
        ref.queryOrdered(byChild: "created_on").queryLimited(toLast: 1).observeSingleEvent(of: .value) { snapshot in
            guard let info = snapshot.value as? [String : Any], info.count == 1 else {
                completion(nil)
                return
            }
            
            let messageKeys = [info.keys.first!]
            
            messagesQuery.getMessages(for: messageKeys) { messages in
                guard messageKeys.count == messages.count,
                    messageKeys == messages.map({ $0.id }) else {
                        completion(nil)
                        return
                }
                
                completion(messages[0])
            }
        }
    }
}
