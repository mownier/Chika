//
//  TypingStatusRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/29/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol TypingStatusRemoteListener: class {

    func listen(callback: @escaping (Person, Bool) -> Void)
}

class TypingStatusRemoteListenerProvider: TypingStatusRemoteListener {
    
    var meID: String
    var chatID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    
    init(chatID: String, meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.chatID = chatID
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
    }
    
    func listen(callback: @escaping (Person, Bool) -> Void) {
        guard !chatID.isEmpty else {
            return
        }
        
        let meID = self.meID
        let personsQuery = self.personsQuery
        let rootRef = database.reference()
        let ref = rootRef.child("chat:typing:status/\(chatID)")
        
        ref.observe(.childChanged) { snapshot in
            guard snapshot.exists() else {
                return
            }
            
            let personKey = snapshot.key
            
            guard meID != personKey else {
                return
            }
            
            let isTyping = snapshot.value as? Bool ?? false
            
            personsQuery.getPersons(for: [personKey]) { persons in
                guard persons.count > 0 else {
                    return
                }
                
                callback(persons[0], isTyping)
            }
        }
    }
}
