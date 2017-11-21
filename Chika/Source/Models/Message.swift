//
//  Message.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

struct Message {

    var id: String
    var date: Date
    var content: String
    var author: Person
    
    init() {
        id = ""
        date = Date()
        content = ""
        author = Person()
    }
}

class MessageQuery {
    
    var database: Database
    var path: String
    
    init(database: Database = Database.database(), path: String = "messages") {
        self.database = database
        self.path = path
    }
    
    func getValues(for keys: [String], completion: @escaping ([Message]) -> Void) {
        let rootRef = database.reference()
        
        var messages = [Message]()
        var messageCounter: UInt = 0 {
            didSet {
                guard messageCounter == keys.count else {
                    return
                }
                
                guard !messages.isEmpty else {
                    completion([])
                    return
                }
                
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
                message.author.id = author
                
                messages.append(message)
                messageCounter += 1
            }
        }
    }
}
