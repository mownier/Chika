//
//  ContactsRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ContactsRemoteQuery: class {

    func getContacts(callback: @escaping ([Contact]) -> Void)
}

class ContactsRemoteQueryProvider: ContactsRemoteQuery {
    
    var meID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    var chatsQuery: ChatsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.chatsQuery = chatsQuery
    }
    
    func getContacts(callback: @escaping ([Contact]) -> Void) {
        let meID = self.meID
        
        guard !meID.isEmpty else {
            callback([])
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        let personsQuery = self.personsQuery
        let chatsQuery = self.chatsQuery
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.hasChildren() else {
                callback([])
                return
            }
            
            var personKeys: [String] = []
            var chatKeys: [String: String] = [:]
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else {
                    continue
                }
                
                guard child.hasChild("chat") else {
                    continue
                }
                
                guard let chatKey = child.childSnapshot(forPath: "chat").value as? String, !chatKey.isEmpty else {
                    continue
                }
                
                chatKeys[child.key] = chatKey
                personKeys.append(child.key)
            }
            
            personKeys = Array(Set(personKeys))
            personsQuery.getPersons(for: personKeys) { persons in
                chatsQuery.getChats(for: chatKeys.map({ $0.value })) { chats in
                    let contacts = persons.map({ person -> Contact in
                        var contact = Contact()
                        contact.person = person
                        
                        if let chatID = chatKeys[person.id], let index = chats.index(where: { $0.id == chatID }) {
                            contact.chat = chats[index]
                        }
                        
                        return contact
                    }).filter({ !$0.chat.id.isEmpty })
                    
                    callback(contacts)
                }
            }
        }
    }
}
