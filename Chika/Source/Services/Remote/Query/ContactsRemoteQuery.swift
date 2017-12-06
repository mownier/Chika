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

    func getContacts(callback: @escaping ([Person]) -> Void)
    func searchPersonsToAdd(with keyword: String, callback: @escaping ([Person]) -> Void)
}

class ContactsRemoteQueryProvider: ContactsRemoteQuery {
    
    var meID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    var emailValidator: EmailValidator
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), emailValidator: EmailValidator = EmailValidatorProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.emailValidator = emailValidator
    }
    
    func getContacts(callback: @escaping ([Person]) -> Void) {
        guard !meID.isEmpty else {
            callback([])
            return
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("person:contacts/\(meID)")
        let personsQuery = self.personsQuery
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.hasChildren() else {
                callback([])
                return
            }
            
            var personKeys: [String] = []
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else {
                    continue
                }
                
                personKeys.append(child.key)
            }
            
            personsQuery.getPersons(for: personKeys) { persons in
                callback(persons)
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
                    
                    personKeys.append(child.key)
                    personKeyCounter += 1
                }
            }
        }
    }
}
