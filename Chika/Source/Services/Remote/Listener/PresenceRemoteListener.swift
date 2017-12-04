//
//  PresenceRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/2/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol PresenceRemoteListener: class {

    func listen(personID: String, callback: @escaping (Bool) -> Void) -> Bool
    func unlisten(personID: String) -> Bool
}

class PresenceRemoteListenerProvider: PresenceRemoteListener {
    
    var database: Database
    var handles: [String: UInt]
    var meID: String
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.database = database
        self.handles = [:]
        self.meID = meID
    }
    
    func listen(personID: String, callback: @escaping (Bool) -> Void) -> Bool {
        guard !personID.isEmpty, personID != meID, handles[personID] == nil else {
            return false
        }
        
        handles[personID] = 0
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:presence/\(personID)/is:active")
        
        rootRef.child("person:contacts/\(meID)/\(personID)").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard snapshot.exists() else {
                self?.handles.removeValue(forKey: personID)
                return
            }
            
            let handle = ref.observe(.value) { snapshot in
                guard snapshot.exists(), snapshot.key == "is:active", let isActive = snapshot.value as? Bool else {
                    return
                }
                
                callback(isActive)
            }
            
            self?.handles[personID] = handle
        }
        
        return true
    }
    
    func unlisten(personID: String) -> Bool {
        guard !personID.isEmpty, let handle = handles.removeValue(forKey: personID), handle != 0  else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:presence/\(personID)")
        ref.removeObserver(withHandle: handle)
        
        return true
    }
}
