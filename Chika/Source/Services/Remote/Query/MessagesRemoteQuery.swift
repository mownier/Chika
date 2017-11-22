//
//  MessagesRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol MessagesRemoteQuery: class {
    
    func getMessages(for keys: [String], completion: @escaping ([Message]) -> Void)
}

protocol MessagesSort: class {
    
    func by(_ keys: [String], _ messages: inout [Message])
}

class MessagesSortProvider: MessagesSort {
    
    func by(_ keys: [String], _ messages: inout [Message]) {
        messages.sort { message1, message2 -> Bool in
            guard let index1 = keys.index(of: message1.id),
                let index2 = keys.index(of: message2.id) else {
                    return false
            }
            
            return index1 < index2
        }
    }
}

class MessagesRemoteQueryProvider: MessagesRemoteQuery {
    
    var personsQuery: PersonsRemoteQuery
    var database: Database
    var path: String
    var sort: MessagesSort
    
    init(database: Database = Database.database(), path: String = "messages", personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), sort: MessagesSort = MessagesSortProvider()) {
        self.database = database
        self.path = path
        self.personsQuery = personsQuery
        self.sort = sort
    }
    
    func getMessages(for keys: [String], completion: @escaping ([Message]) -> Void) {
        guard !keys.isEmpty else {
            completion([])
            return
        }
        
        let rootRef = database.reference()
        let personsQuery = self.personsQuery
        
        var messages = [Message]()
        var messageCounter: UInt = 0 {
            didSet {
                guard messageCounter == keys.count else {
                    return
                }
                
                sort.by(keys, &messages)
                completion(messages)
            }
        }
        
        for key in keys {
            let ref = rootRef.child("\(path)/\(key)")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let info = snapshot.value as? [String : Any] else {
                    messageCounter += 1
                    return
                }
                
                let author = info["author"] as? String ?? ""
                let content = info["content"] as? String ?? ""
                let createdOn = (info["created_on"] as? Double ?? 0) / 1000
                
                var message = Message()
                message.id = key
                message.content = content
                message.date = Date(timeIntervalSince1970: createdOn)
                
                let personKeys = [author]
                
                personsQuery.getPersons(for: personKeys) { persons in
                    guard personKeys.count == persons.count,
                        personKeys == persons.map({ $0.id }) else {
                            messageCounter += 1
                            return
                    }
                    
                    message.author = persons[0]
                    messages.append(message)
                    messageCounter += 1
                }
            }
        }
    }
}

