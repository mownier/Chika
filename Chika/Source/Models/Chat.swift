//
//  Chat.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

struct Chat {

    var id: String
    var recent: Message
    var participants: [Person]
    var title: String
    var creator: String
    
    var hasOnlineParticipants: Bool {        
        for person in participants {
            if person.isOnline {
                return true
            }
        }
        
        return false
    }
    
    init() {
        id = ""
        title = ""
        recent = Message()
        participants = []
        creator = ""
    }
}

extension Chat: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        
        id          : \(id)
        title       : \(title)
        recent      : \(recent)
        creator     : \(creator)
        participants: \(participants)
        
        """
    }
}

class ChatQuery {
    
    var database: Database
    var path: String
    
    init(database: Database = Database.database(), path: String = "chats") {
        self.database = database
        self.path = path
    }
    
    func getValues(for keys: [String], completion: @escaping ([Chat]) -> Void) {
        let rootRef = database.reference()
        
        var chats = [Chat]()
        var chatCounter: UInt = 0 {
            didSet {
                guard chatCounter == keys.count else {
                    return
                }
                
                completion(chats)
            }
        }
        
        for key in keys {
            guard !key.isEmpty else {
                chatCounter += 1
                continue
            }
            
            let ref = rootRef.child("\(path)/\(key)")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let info = snapshot.value as? [String : Any],
                    let participants = info["participants"] as? [String: Any] else {
                        chatCounter += 1
                        return
                }
                
                var chat = Chat()
                chat.id = key
                chat.title = info["title"] as? String ?? ""
                chat.creator = info["creator"] as? String ?? ""
                chat.participants = participants.flatMap({
                    var person = Person()
                    person.id = $0.key
                    return person
                })
                
                let ref = rootRef.child("chat:messages/\(key)")
                let query = ref.queryOrdered(byChild: "created_on").queryLimited(toLast: 1)
                
                query.observeSingleEvent(of: .value) { snapshot in
                    guard let info = snapshot.value as? [String : Any], info.count == 1,
                        let messageID = info.keys.first, !messageID.isEmpty else {
                            chatCounter += 1
                            return
                    }
                    chat.recent.id = messageID
                    chats.append(chat)
                    chatCounter += 1
                }
            }
        }
    }
}
