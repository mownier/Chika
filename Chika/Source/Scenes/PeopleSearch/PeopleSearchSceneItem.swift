//
//  PeopleSearchSceneItem.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct PeopleSearchSceneItem {

    enum RequestStatus {
        
        case none, sending, sent, retry, pending
    }
    
    var object: PersonSearchObject
    var requestStatus: RequestStatus
    var isActive: Bool
    
    init(object: PersonSearchObject) {
        self.object = object
        self.isActive = false
        self.requestStatus = object.isPending ? .pending : object.isRequested ? .sent : .none
    }
}
