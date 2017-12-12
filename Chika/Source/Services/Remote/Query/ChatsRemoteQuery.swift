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

protocol ChatsSort: class {
    
    func by(_ keys: [String], _ chats: inout [Chat])
}

class ChatsSortProvider: ChatsSort {
    
    func by(_ keys: [String], _ chats: inout [Chat]) {
        chats.sort { chat1, chat2 -> Bool in
            guard let index1 = keys.index(of: chat1.id),
                let index2 = keys.index(of: chat2.id) else {
                    return false
            }
            
            return index1 < index2
        }
    }
}

class ChatsRemoteQueryProvider: ChatsRemoteQuery {
    
    var recentMessageQuery: RecentMessageRemoteQuery
    var personsQuery: PersonsRemoteQuery
    var database: Database
    var path: String
    var sort: ChatsSort
    
    init(database: Database = Database.database(), path: String = "chats", personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), recentMessageQuery: RecentMessageRemoteQuery = RecentMessageRemoteQueryProvider(), sort: ChatsSort = ChatsSortProvider()) {
        self.database = database
        self.path = path
        self.personsQuery = personsQuery
        self.recentMessageQuery = recentMessageQuery
        self.sort = sort
    }
    
    func getChats(for keys: [String], completion: @escaping ([Chat]) -> Void) {
        guard !keys.isEmpty else {
            completion([])
            return
        }
        
        let rootRef = database.reference()
        let personsQuery = self.personsQuery
        let recentMessageQuery = self.recentMessageQuery
        
        var chats = [Chat]()
        var chatCounter: UInt = 0 {
            didSet {
                guard chatCounter == keys.count else {
                    return
                }
                
                sort.by(keys, &chats)
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
                
                let personKeys: [String] = participants.flatMap({ $0.key })
                
                personsQuery.getPersons(for: personKeys) { persons in
                    guard personKeys.count == persons.count,
                        personKeys == persons.map({ $0.id }) else {
                            chatCounter += 1
                            return
                    }
                    
                    chat.participants = persons
                    
                    recentMessageQuery.getRecentMessage(for: key) { message in
                        chat.recent = message == nil ? Message() : message!
                        chats.append(chat)
                        chatCounter += 1
                    }
                }
            }
        }
    }
}

