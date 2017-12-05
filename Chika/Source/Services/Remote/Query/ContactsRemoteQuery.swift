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
}

class ContactsRemoteQueryProvider: ContactsRemoteQuery {
    
    var meID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
    }
    
    func getContacts(callback: @escaping ([Person]) -> Void) {
        guard !meID.isEmpty else {
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
}
