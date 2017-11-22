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


