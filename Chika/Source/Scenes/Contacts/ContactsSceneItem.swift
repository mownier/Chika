//
//  ContactsSceneItem.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ContactsSceneItem {
    
    var contact: Contact
    var isActive: Bool
    var name: String {
        guard !contact.person.displayName.isEmpty else {
            return contact.person.name
        }
        
        return contact.person.displayName
    }
    
    init(contact: Contact) {
        self.contact = contact
        self.isActive = false
    }
}
