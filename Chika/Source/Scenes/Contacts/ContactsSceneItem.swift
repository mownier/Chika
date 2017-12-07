//
//  ContactsSceneItem.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ContactsSceneItem {

    enum RequestStatus {
        
        case none
        case sending
        case sent
        case failed
    }
    
    var person: Person
    var isActive: Bool
    var requestStatus: RequestStatus
    
    init(person: Person) {
        self.person = person
        self.isActive = false
        self.requestStatus = .none
    }
}
