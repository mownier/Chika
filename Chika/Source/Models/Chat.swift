//
//  Chat.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct Chat {

    var id: String
    var recent: Message
    var participants: [Person]
    var title: String
    var creator: String
    
    init() {
        id = ""
        title = ""
        recent = Message()
        participants = []
        creator = ""
    }
}

extension Chat: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}

