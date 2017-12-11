//
//  ContactRequestRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ContactRequestRemoteListener: class {

    func listen(callback: @escaping (Contact.Request) -> Void) -> Bool
    func unlisten() -> Bool
}

class ContactRequestRemoteListenerProvider: ContactRequestRemoteListener {
    
    var meID: String
    var database: Database
    var handles: [String: UInt]
    var personsQuery: PersonsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.handles = [:]
        self.personsQuery = personsQuery
    }
    
    func listen(callback: @escaping (Contact.Request) -> Void) -> Bool {
        let meID = self.meID
        guard !meID.isEmpty else {
            return false
        }
        
        let personsQuery = self.personsQuery
        let rootRef = database.reference()
        let ref = rootRef.child("person:contact:request:established/\(meID)")
        let query = ref.queryOrdered(byChild: "requestee").queryEqual(toValue: meID)
        let handle = query.observe(.childAdded) { snapshot in
            guard snapshot.exists(), !snapshot.key.isEmpty,
                let value = snapshot.value as? [String: Any] else {
                return
            }
            
            personsQuery.getPersons(for: [snapshot.key]) { persons in
                let persons = Array(Set(persons)).filter({ $0.id == snapshot.key })
                guard persons.count == 1 else {
                    return
                }
                
                var request = Contact.Request()
                request.id = value["id"] as? String ?? ""
                request.message = value["message"] as? String ?? ""
                request.createdOn = value["created:on"] as? Double ?? 0
                request.requestee = persons[0]
                
                callback(request)
            }
        }
        
        handles["onListen"] = handle
        return true
    }
    
    func unlisten() -> Bool {
        guard !meID.isEmpty, let handle = handles["onListen"] else {
            return false
        }
        

        let rootRef = database.reference()
        let ref = rootRef.child("person:contact:request:established/\(meID)")
        let query = ref.queryOrdered(byChild: "requestee").queryEqual(toValue: meID)
        query.removeObserver(withHandle: handle)
        return true
    }
}
