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

    func listen(personID: String, callback: @escaping (Presence) -> Void) -> Bool
    func unlisten(personID: String) -> Bool
    func unlistenAll() -> Bool
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
    
    func listen(personID: String, callback: @escaping (Presence) -> Void) -> Bool {
        guard !personID.isEmpty, personID != meID, handles[personID] == nil else {
            return false
        }
        
        handles[personID] = 0
        
        let rootRef = database.reference()
        
        rootRef.child("person:contacts/\(meID)/\(personID)").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard snapshot.exists() else {
                self?.handles.removeValue(forKey: personID)
                return
            }
            
            let ref = rootRef.child("person:presence/\(personID)")
            let handle = ref.observe(.value) { snapshot in
                guard snapshot.exists() else {
                    return
                }
                
                var presence = Presence()
                presence.personID = personID
                presence.isActive = snapshot.childSnapshot(forPath: "is:active").value as? Bool ?? false
                presence.activeOn = (snapshot.childSnapshot(forPath: "active:on").value as? Double ?? 0) / 1000
                
                callback(presence)
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
    
    func unlistenAll() -> Bool {
        guard !handles.isEmpty else {
            return false
        }
        
        var result = true
        for (personID, _) in handles {
            result = result && unlisten(personID: personID)
        }
        return result
    }
}
