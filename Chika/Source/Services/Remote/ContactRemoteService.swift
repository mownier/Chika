//
//  ContactRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRemoteService: class {

    func getContacts(callback: @escaping (ServiceResult<[Person]>) -> Void)
    func searchPersonsToAdd(with keyword: String, callback: @escaping (ServiceResult<[Person]>) -> Void)
    func sendContactRequest(to personID: String, message: String, callback: @escaping (ServiceResult<String>) -> Void)
}

class ContactRemoteServiceProvider: ContactRemoteService {
    
    var contactsQuery: ContactsRemoteQuery
    var contactWriter: ContactRemoteWriter
    
    init(contactsQuery: ContactsRemoteQuery = ContactsRemoteQueryProvider(), contactWriter: ContactRemoteWriter = ContactRemoteWriterProvider()) {
        self.contactsQuery = contactsQuery
        self.contactWriter = contactWriter
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
    
    func searchPersonsToAdd(with keyword: String, callback: @escaping (ServiceResult<[Person]>) -> Void) {
        contactsQuery.searchPersonsToAdd(with: keyword) { persons in
            guard !persons.isEmpty else {
                callback(.err(ServiceError("no persons found")))
                return
            }
            
            callback(.ok(persons))
        }
    }
    
    func sendContactRequest(to personID: String, message: String, callback: @escaping (ServiceResult<String>) -> Void) {
        contactWriter.sendContactRequest(to: personID, message: message) { error in
            guard error == nil else {
                callback(.err(error!))
                return
            }
            
            callback(.ok("OK"))
        }
    }
}
