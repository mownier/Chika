//
//  ChatCreatorSceneItem.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ChatCreatorSceneItem {

    var contact: Contact
    var isSelected: Bool
    
    init(contact: Contact) {
        self.contact = contact
        self.isSelected = false
    }
}
