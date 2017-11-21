//
//  ChatRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatRemoteService: class {

    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void)
}

class ChatRemoteServiceProvider: ChatRemoteService {
    
    struct Query {
        
        var person: PersonQuery
        var message: MessageQuery
        var chat: ChatQuery
        
        init(person: PersonQuery = PersonQuery(), message: MessageQuery = MessageQuery(), chat: ChatQuery = ChatQuery()) {
            self.person = person
            self.message = message
            self.chat = chat
        }
    }
    
    var database: Database
    var query: Query
    
    init(database: Database = Database.database(), query: Query = Query()) {
        self.database = database
        self.query = query
    }
    
    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void) {
        guard !userID.isEmpty else {
            completion(.err(ServiceError("can not get inbox because user ID is empty")))
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:inbox/\(userID)")
        let query = self.query
        
        ref.queryOrdered(byChild: "updated_on").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.childrenCount > 0 else {
                completion(.err(ServiceError("inbox is empty")))
                return
            }
            
            var chatKeys: [String] = []
            var inbox = [Chat]()
            var inboxCounter: UInt = 0 {
                didSet {
                    guard inboxCounter == chatKeys.count  else {
                        return
                    }
                    
                    completion(.ok(inbox.reversed()))
                }
            }
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else {
                    continue
                }
                
                chatKeys.append(child.key)
            }
            
            query.chat.getValues(for: chatKeys) { chats in
                guard !chats.isEmpty else {
                    completion(.err(ServiceError("inbox is empty")))
                    return
                }
                
                for chat in chats {
                    var inboxChat = chat
                    let personKeys = chat.participants.map({ $0.id })
                    query.person.getValues(for: personKeys) { persons in
                        let messageKeys = [chat.recent.id]
                        query.message.getValues(for: messageKeys) { messages in
                            inboxChat.participants = persons
                            inboxChat.recent = messages[0]
                            inbox.append(inboxChat)
                            inboxCounter += 1
                        }
                    }
                }
            }
        }
    }
}
