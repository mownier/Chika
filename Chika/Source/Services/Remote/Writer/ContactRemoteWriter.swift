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

    func revokeSentRequest(withID id: String, callback: @escaping (Error?) -> Void)
    func acceptPendingRequest(withID id: String, callback: @escaping (Error?) -> Void)
    func ignorePendingRequest(withID id: String, callback: @escaping (Error?) -> Void)
    func sendContactRequest(to personID: String, message: String, callback: @escaping (Error?) -> Void)
}

class ContactRemoteWriterProvider: ContactRemoteWriter {
    
    private enum Request: String {
        
        case sent = "sent"
        case pending = "pending"
    }
    
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
        let requestsRef = rootRef.child("contact:requests")
        let key = requestsRef.childByAutoId().key
        
        let newRequest: [AnyHashable: Any] = [
            "id": key,
            "message": message,
            "requestor": meID,
            "requestee": personID,
            "created:on": ServerValue.timestamp()
        ]
        
        let values: [AnyHashable: Any] = [
            "contact:requests/\(key)": newRequest,
            "person:contact:request:established/\(meID)/\(personID)": newRequest,
            "person:contact:request:established/\(personID)/\(meID)": newRequest
        ]
        
        rootRef.updateChildValues(values) { error, _ in
            guard error == nil else {
                callback(error)
                return
            }
            
            callback(nil)
        }
    }
    
    func revokeSentRequest(withID id: String, callback: @escaping (Error?) -> Void) {
        removeRequest(.sent, id, callback)
    }
    
    func ignorePendingRequest(withID id: String, callback: @escaping (Error?) -> Void) {
        removeRequest(.pending, id, callback)
    }
    
    func acceptPendingRequest(withID id: String, callback: @escaping (Error?) -> Void) {
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
            
            let chatsRef = rootRef.child("chats")
            let key = chatsRef.childByAutoId().key
            let newChat: [String: Any] = [
                "created_on": ServerValue.timestamp(),
                "updated_on": ServerValue.timestamp(),
                "id": key,
                "participants":[
                    "\(requestor)": true,
                    "\(requestee)": true
                ]
            ]
            
            let values: [AnyHashable: Any] = [
                "chats/\(key)": newChat,
                "person:contacts/\(requestor)/\(requestee)/chat/\(key)": true,
                "person:contacts/\(requestee)/\(requestor)/chat/\(key)": true,
                "person:contact:request:established/\(requestor)/\(requestee)": NSNull(),
                "person:contact:request:established/\(requestee)/\(requestor)": NSNull(),
                "contact:requests/\(id)": NSNull()
            ]
            
            rootRef.updateChildValues(values) { error, _ in
                callback(error)
            }
        }
    }
    
    private func removeRequest(_ request: Request, _ id: String, _ callback: @escaping (Error?) -> Void) {
        guard !id.isEmpty else {
            callback(RemoteWriterError("\(request.rawValue) request ID is empty"))
            return
        }
        
        let meID = self.meID
        
        guard !meID.isEmpty else {
            callback(RemoteWriterError("current user ID is empty"))
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contact:request:established/\(meID)")
        let query = ref.queryOrdered(byChild: "id").queryEqual(toValue: id)
        query.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                callback(RemoteWriterError("\(request.rawValue) request not found"))
                return
            }
            
            guard snapshot.childrenCount == 1, snapshot.children.allObjects.count == 1 else {
                callback(RemoteWriterError("snapshot child count is not 1"))
                return
            }
            
            guard let child = snapshot.children.allObjects[0] as? DataSnapshot else {
                callback(RemoteWriterError("snapshot child is nil"))
                return
            }
            
            guard !child.key.isEmpty else {
                callback(RemoteWriterError("child snapshot key is empty"))
                return
            }
            
            let values: [String: Any] = [
                "contact:requests/\(id)": NSNull(),
                "person:contact:request:established/\(child.key)/\(meID)": NSNull(),
                "person:contact:request:established/\(meID)/\(child.key)": NSNull()
            ]
            
            rootRef.updateChildValues(values) { error, _ in
                callback(error)
            }
        }
    }
}
