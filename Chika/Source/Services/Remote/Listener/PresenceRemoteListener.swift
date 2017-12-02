//
//  PresenceRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/2/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol PresenceRemoteListener: class {

    func listen(personID: String, callback: @escaping (Bool) -> Void) -> Bool
    func unlisten(personID: String) -> Bool
}

class PresenceRemoteListenerProvider: PresenceRemoteListener {
    
    var database: Database
    var info: [String: UInt]
    
    init(database: Database = Database.database()) {
        self.database = database
        self.info = [:]
    }
    
    func listen(personID: String, callback: @escaping (Bool) -> Void) -> Bool {
        guard !personID.isEmpty else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:presence/\(personID)")
        let handle = ref.observe(.childChanged) { snapshot in
            guard snapshot.key == "is:active", let isActive = snapshot.value as? Bool else {
                return
            }
            
            callback(isActive)
        }
        
        info[personID] = handle
        return true
    }
    
    func unlisten(personID: String) -> Bool {
        guard !personID.isEmpty, let handle = info[personID] else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:presence/\(personID)")
        ref.removeObserver(withHandle: handle)
        return true
    }
}
