//
//  ContactsSceneItem.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ContactsSceneItem {

    var person: Person
    var isActive: Bool
    
    init(person: Person) {
        self.person = person
        self.isActive = false
    }
}
