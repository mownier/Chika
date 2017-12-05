//
//  ContactRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRemoteService: class {

    func getContacts(callback: @escaping (ServiceResult<[Person]>) -> Void)
}

class ContactRemoteServiceProvider: ContactRemoteService {
    
    var contactsQuery: ContactsRemoteQuery
    
    init(contactsQuery: ContactsRemoteQuery = ContactsRemoteQueryProvider()) {
        self.contactsQuery = contactsQuery
    }
    
    func getContacts(callback: @escaping (ServiceResult<[Person]>) -> Void) {
        contactsQuery.getContacts { contacts in
            guard !contacts.isEmpty else {
                callback(.err(ServiceError("no contacts")))
                return
            }
            
            callback(.ok(contacts))
        }
    }
}
