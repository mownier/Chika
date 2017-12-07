//
//  ContactRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/6/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ContactRemoteWriter: class {

    func approveContactRequest(withID id: String, callback: @escaping (Error?) -> Void)
    func sendContactRequest(to personID: String, message: String, callback: @escaping (Error?) -> Void)
}

class ContactRemoteWriterProvider: ContactRemoteWriter {
    
    var meID: String
    var database: Database
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.meID = meID
        self.database = database
    }
    
    func sendContactRequest(to personID: String, message: String, callback: @escaping (Error?) -> Void) {
        let meID = self.meID
        
        guard !meID.isEmpty else {
            callback(RemoteWriterError("current user ID is empty"))
            return
        }
        
        let rootRef = database.reference()
        let key = rootRef.child("contact:requests").childByAutoId().key
        let requestsRef = rootRef.child("contact:requests/\(key)")
        let value = ["message": message, "requestor": meID, "requestee": personID]
        requestsRef.setValue(value) { error, _ in
            guard error == nil else {
                callback(error)
                return
            }
            
            let sentRef = rootRef.child("person:contact:request:sent/\(meID)/\(key)")
            sentRef.setValue(true) { error, _ in
                guard error == nil else {
                    callback(error)
                    return
                }
                
                let pendingRef = rootRef.child("person:contact:request:pending/\(personID)/\(key)")
                pendingRef.setValue(true) { error, _ in
                    guard error == nil else {
                        callback(error)
                        return
                    }
                    
                    callback(nil)
                }
            }
        }
    }
    
    func approveContactRequest(withID id: String, callback: @escaping (Error?) -> Void) {
        let meID = self.meID
        
        guard !meID.isEmpty else {
            callback(RemoteWriterError("current user ID is empty"))
            return
        }
        
        let rootRef = database.reference()
        let requestsRef = rootRef.child("contact:requests/\(id)")
        requestsRef.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                callback(RemoteWriterError("contact request not found"))
                return
            }
            
            guard let value = snapshot.value as? [String: Any] else {
                callback(RemoteWriterError("contact request info is not a dictionary"))
                return
            }
            
            guard let requestor = value["requestor"] as? String, !requestor.isEmpty else {
                callback(RemoteWriterError("contact request has no requestor"))
                return
            }
            
            guard let requestee = value["requestee"] as? String, !requestee.isEmpty, requestee == meID else {
                callback(RemoteWriterError("contact request requestee is not you"))
                return
            }
            
            let contactsRef = rootRef.child("person:contacts/\(requestee)")
            contactsRef.child(requestor).observeSingleEvent(of: .value) { snapshot in
                guard !snapshot.exists() else {
                    callback(RemoteWriterError("person already a contact"))
                    return
                }
                
                let pendingRef = rootRef.child("person:contact:request:pending/\(requestee)/\(id)")
                pendingRef.observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.exists() else {
                        callback(RemoteWriterError("not a pending contact request"))
                        return
                    }
                    
                    let sentRef = rootRef.child("person:contact:request:sent/\(requestor)/\(id)")
                    sentRef.observeSingleEvent(of: .value) { snapshot in
                        guard snapshot.exists() else {
                            callback(RemoteWriterError("sent contact request not found"))
                            return
                        }
                        
                        let value = ["person:contacts/\(requestor)/\(requestee)": true, "person:contacts/\(requestee)/\(requestor)": true]
                        rootRef.setValue(value) { error, _ in
                            callback(error)
                        }
                    }
                }
            }
        }
    }
}
