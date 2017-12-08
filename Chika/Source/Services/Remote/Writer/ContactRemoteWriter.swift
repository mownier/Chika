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
    var chatWriter: ChatRemoteWriter
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), chatWriter: ChatRemoteWriter = ChatRemoteWriterProvider()) {
        self.meID = meID
        self.database = database
        self.chatWriter = chatWriter
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
        let requestValue: [AnyHashable: Any] = ["id": key, "message": message, "requestor": meID, "requestee": personID, "created:on": ServerValue.timestamp()]
        let values: [AnyHashable: Any] = [
            "contact:requests/\(key)": requestValue,
            "person:contact:request:established/\(meID)/\(personID)": requestValue,
            "person:contact:request:established/\(personID)/\(meID)": requestValue,
        ]
        
        rootRef.updateChildValues(values) { error, _ in
            guard error == nil else {
                callback(error)
                return
            }
            
            callback(nil)
        }
    }
    
    func approveContactRequest(withID id: String, callback: @escaping (Error?) -> Void) {
        let meID = self.meID
        
        guard !meID.isEmpty else {
            callback(RemoteWriterError("current user ID is empty"))
            return
        }
        
        let chatWriter = self.chatWriter
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
            
            chatWriter.createNewChat(for: [requestor, requestee]) { result in
                switch result {
                case .err(let info):
                    callback(info)
                    
                case .ok(let chat):
                    guard !chat.id.isEmpty else {
                        callback(RemoteWriterError("chat ID is empty"))
                        return
                    }
                    
                    let chatValue = [chat.id: true]
                    let values: [AnyHashable: Any] = [
                        "person:contacts/\(requestor)/\(requestee)/chat": chatValue,
                        "person:contacts/\(requestee)/\(requestor)/chat": chatValue,
                        "person:contact:request:established/\(requestor)/\(requestee)": NSNull(),
                        "person:contact:request:established/\(requestee)/\(requestor)": NSNull()
                    ]
                    rootRef.updateChildValues(values) { error, _ in
                        callback(error)
                    }
                }
            }
        }
    }
}
