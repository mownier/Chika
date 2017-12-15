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
    
    init(contact: Contact) {
        self.contact = contact
        self.isActive = false
    }
}
