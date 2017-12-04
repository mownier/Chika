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

    func listen(for chatID: String, callback: @escaping (String, Bool) -> Void) -> Bool
    func unlisten(for chatID: String) -> Bool
}

class TypingStatusRemoteListenerProvider: TypingStatusRemoteListener {
    
    var meID: String
    var handles: [String: UInt]
    var database: Database
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.handles = [:]
        self.meID = meID
        self.database = database
    }
    
    func unlisten(for chatID: String) -> Bool {
        guard !chatID.isEmpty, let handle = handles[chatID] else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("chat:typing:status/\(chatID)")
        ref.child(meID).setValue(false) { _, _ in }
        ref.removeObserver(withHandle: handle)
        return true
    }
    
    func listen(for chatID: String, callback: @escaping (String, Bool) -> Void) -> Bool {
        guard !chatID.isEmpty else {
            return false
        }
        
        let meID = self.meID
        let rootRef = database.reference()
        let ref = rootRef.child("chat:typing:status/\(chatID)")
        
        ref.child(meID).onDisconnectSetValue(false)
        let handle = ref.observe(.childChanged) { snapshot in
            guard snapshot.exists() else {
                return
            }
            
            let personKey = snapshot.key
            
            guard meID != personKey else {
                return
            }
            
            let isTyping = snapshot.value as? Bool ?? false
            
            callback(personKey, isTyping)
        }
        handles[chatID] = handle
        
        return true
    }
}
