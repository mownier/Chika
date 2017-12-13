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

    func listenOnAddedContact(callback: @escaping (Contact) -> Void) -> Bool
    func listenOnRemovedContact(callback: @escaping (String) -> Void) -> Bool
    func unlistenOnAddedConctact() -> Bool
    func unlistenOnRemovedContact() -> Bool
}

class ContactRemoteListenerProvider: ContactRemoteListener {
    
    var meID: String
    var database: Database
    var handles: [String: UInt]
    var personsQuery: PersonsRemoteQuery
    var chatsQuery: ChatsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.chatsQuery = chatsQuery
        self.handles = [:]
    }
    
    func listenOnAddedContact(callback: @escaping (Contact) -> Void) -> Bool {
        let meID = self.meID
        
        guard !meID.isEmpty else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        let personsQuery = self.personsQuery
        let chatsQuery = self.chatsQuery
        
        let handle = ref.observe(.childAdded) { snapshot in
            guard snapshot.exists(), snapshot.hasChild("chat") else {
                return
            }
            
            let chatID = snapshot.childSnapshot(forPath: "chat").value as? String ?? ""
            
            guard !chatID.isEmpty else {
                return
            }
            
            personsQuery.getPersons(for: [snapshot.key]) { persons in
                chatsQuery.getChats(for: [chatID]) { chats in
                    guard persons.count == 1, chats.count == 1 else {
                        return
                    }
                    
                    var contact = Contact()
                    contact.person = persons[0]
                    contact.chat = chats[0]
                    
                    callback(contact)
                }
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
