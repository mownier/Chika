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

    func listenOnAdded(callback: @escaping (Contact.Request) -> Void) -> Bool
    func listenOnRemoved(callback: @escaping (Contact.Request) -> Void) -> Bool
    func unlistenOnAdded() -> Bool
    func unlistenOnRemoved() -> Bool
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
    
    func listenOnAdded(callback: @escaping (Contact.Request) -> Void) -> Bool {
        let personsQuery = self.personsQuery
        let observer: (DatabaseQuery, String) -> DatabaseQuery = { ref, meID in
            return ref.queryOrdered(byChild: "requestee").queryEqual(toValue: meID)
        }
        let block: (DataSnapshot) -> Void = { snapshot in
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
        return processListen("onAdded", .childAdded, observer, block)
    }
    
    func listenOnRemoved(callback: @escaping (Contact.Request) -> Void) -> Bool {
        let personsQuery = self.personsQuery
        let observer: (DatabaseQuery, String) -> DatabaseQuery = { ref, _ in
            return ref
        }
        let block: (DataSnapshot) -> Void = { snapshot in
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
        return processListen("onRemoved", .childRemoved, observer, block)
    }
    
    func unlistenOnAdded() -> Bool {
        return processUnlisten("onAdded") { ref, meID in
            return ref.queryOrdered(byChild: "requestee").queryEqual(toValue: meID)
        }
    }
    
    func unlistenOnRemoved() -> Bool {
        return processUnlisten("onRemoved") { ref, _ in
            return ref
        }
    }
    
    private func processListen(_ handleKey: String, _ event: DataEventType, _ observer: @escaping (DatabaseQuery, String) -> DatabaseQuery, _ block: @escaping (DataSnapshot) -> Void) -> Bool {
        let meID = self.meID
        guard !meID.isEmpty, handles[handleKey] == nil else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contact:request:established/\(meID)")
        let query = observer(ref, meID)
        let handle = query.observe(event) { snapshot in
            block(snapshot)
        }
        
        handles[handleKey] = handle
        return true
    }
    
    private func processUnlisten(_ handleKey: String, _ observer: @escaping (DatabaseQuery, String) -> DatabaseQuery) -> Bool {
        guard !meID.isEmpty, let handle = handles.removeValue(forKey: handleKey), handle != 0 else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contact:request:established/\(meID)")
        let query = observer(ref, meID)
        query.removeObserver(withHandle: handle)
        return true
    }
}
