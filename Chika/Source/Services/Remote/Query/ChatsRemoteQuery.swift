//
//  ChatsRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatsRemoteQuery: class {
    
    func getChats(for keys: [String], completion: @escaping ([Chat]) -> Void)
}

class ChatsRemoteQueryProvider: ChatsRemoteQuery {
    
    var recentMessageQuery: RecentMessageRemoteQuery
    var personQuery: PersonsRemoteQuery
    var database: Database
    var path: String
    
    init(database: Database = Database.database(), path: String = "chats", personQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), recentMessageQuery: RecentMessageRemoteQuery = RecentMessageRemoteQueryProvider()) {
        self.database = database
        self.path = path
        self.personQuery = personQuery
        self.recentMessageQuery = recentMessageQuery
    }
    
    func getChats(for keys: [String], completion: @escaping ([Chat]) -> Void) {
        let rootRef = database.reference()
        let personQuery = self.personQuery
        let recentMessageQuery = self.recentMessageQuery
        
        var chats = [Chat]()
        var chatCounter: UInt = 0 {
            didSet {
                guard chatCounter == keys.count else {
                    return
                }
                
                chats.sort { chat1, chat2 -> Bool in
                    guard let index1 = keys.index(of: chat1.id),
                        let index2 = keys.index(of: chat2.id) else {
                            return false
                    }
                    
                    return index1 < index2
                }
                
                completion(chats)
            }
        }
        
        for key in keys {
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
                
                let personKeys: [String] = participants.flatMap({ $0.key })
                
                personQuery.getPersons(for: personKeys) { persons in
                    guard personKeys.count == persons.count,
                        personKeys == persons.map({ $0.id }) else {
                            chatCounter += 1
                            return
                    }
                    
                    chat.participants = persons
                    
                    recentMessageQuery.getRecentMessage(for: key) { message in
                        guard let recent = message else {
                            chatCounter += 1
                            return
                        }
                        
                        chat.recent = recent
                        chats.append(chat)
                        chatCounter += 1
                    }
                }
            }
        }
    }
}

