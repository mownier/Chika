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
    func searchPersonsToAdd(with keyword: String, callback: @escaping ([Person]) -> Void)
}

class ContactsRemoteQueryProvider: ContactsRemoteQuery {
    
    var meID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    var chatsQuery: ChatsRemoteQuery
    var emailValidator: EmailValidator
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider(), emailValidator: EmailValidator = EmailValidatorProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.chatsQuery = chatsQuery
        self.emailValidator = emailValidator
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
                
                let chat = child.childSnapshot(forPath: "chat")
                
                guard let value = chat.value as? [String: Bool], value.count == 1, value.keys.count == 1,
                    let chatKey = value.keys.first, !chatKey.isEmpty else {
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
    
    func searchPersonsToAdd(with keyword: String, callback: @escaping ([Person]) -> Void) {
        let meID = self.meID
        
        guard !meID.isEmpty, !keyword.isEmpty else {
            callback([])
            return
        }
        
        var path = "name"
        var searchText = keyword.lowercased()
        if emailValidator.isValid(keyword) {
            let words = searchText.split(separator: "@")
            if !words.isEmpty {
                searchText = String(words[0])
                path = "email"
            }
        }
        
        let personsQuery = self.personsQuery
        let rootRef = database.reference()
        let ref = rootRef.child("persons:search")
        let query = ref.queryOrdered(byChild: path).queryStarting(atValue: searchText).queryEnding(atValue: searchText+"\u{f8ff}")
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.hasChildren() else {
                return callback([])
            }
            
            var personKeys = [String]()
            var personKeyCounter: UInt = 0 {
                didSet {
                    guard personKeyCounter == snapshot.childrenCount else {
                        return
                    }
                    
                    guard !personKeys.isEmpty else {
                        callback([])
                        return
                    }
                    
                    personsQuery.getPersons(for: personKeys) { persons in
                        callback(persons)
                    }
                }
            }
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot, child.key != meID else {
                    personKeyCounter += 1
                    continue
                }
                
                let ref = rootRef.child("person:contacts/\(meID)/\(child.key)")
                ref.observeSingleEvent(of: .value)  { snapshot in
                    guard !snapshot.exists() else {
                        personKeyCounter += 1
                        return
                    }
                    
                    let establishedRef = rootRef.child("person:contact:request:established/\(meID)/\(child.key)")
                    establishedRef.observeSingleEvent(of: .value) { snapshot in
                        guard !snapshot.exists() else {
                            personKeyCounter += 1
                            return
                        }
                        
                        personKeys.append(child.key)
                        personKeyCounter += 1
                    }
                }
            }
        }
    }
}
