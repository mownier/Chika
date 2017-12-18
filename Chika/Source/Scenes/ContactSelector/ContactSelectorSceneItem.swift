//
//  ContactSelectorSceneItem.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ContactSelectorSceneItem {

    var contact: Contact
    var isSelected: Bool
    
    init(contact: Contact) {
        self.contact = contact
        self.isSelected = false
    }
}
