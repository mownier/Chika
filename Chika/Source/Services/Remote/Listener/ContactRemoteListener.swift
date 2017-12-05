//
//  ContactRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ContactRemoteListener: class {

    func listenOnAddedContact(callback: @escaping (Person) -> Void) -> Bool
    func listenOnRemovedContact(callback: @escaping (String) -> Void) -> Bool
    func unlistenOnAddedConctact() -> Bool
    func unlistenOnRemovedContact() -> Bool
}

class ContactRemoteListenerProvider: ContactRemoteListener {
    
    var meID: String
    var database: Database
    var handles: [String: UInt]
    var personsQuery: PersonsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.handles = [:]
    }
    
    func listenOnAddedContact(callback: @escaping (Person) -> Void) -> Bool {
        guard !meID.isEmpty else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        let personsQuery = self.personsQuery
        
        let handle = ref.observe(.childAdded) { snapshot in
            guard snapshot.exists() else {
                return
            }
            
            personsQuery.getPersons(for: [snapshot.key]) { persons in
                guard persons.count == 1 else {
                    return
                }
                
                callback(persons[0])
            }
        }
        
        handles["onAdded"] = handle
        return true
    }
    
    func listenOnRemovedContact(callback: @escaping (String) -> Void) -> Bool {
        guard !meID.isEmpty else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        let handle = ref.observe(.childRemoved) { snapshot in
            guard snapshot.exists(), !snapshot.key.isEmpty else {
                return
            }
            
            callback(snapshot.key)
        }
        
        handles["onRemoved"] = handle
        return true
    }
    
    func unlistenOnAddedConctact() -> Bool {
        guard !meID.isEmpty, let handle = handles["onAdded"] else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        ref.removeObserver(withHandle: handle)
        return true
    }
    
    func unlistenOnRemovedContact() -> Bool {
        guard !meID.isEmpty, let handle = handles["onRemoved"] else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        ref.removeObserver(withHandle: handle)
        return true
    }
}
