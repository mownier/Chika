//
//  ContactRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRemoteService: class {

    func getContacts(callback: @escaping (ServiceResult<[Contact]>) -> Void)
    func searchPersonsToAdd(with keyword: String, callback: @escaping (ServiceResult<[Person]>) -> Void)
    func sendContactRequest(to personID: String, message: String, callback: @escaping (ServiceResult<String>) -> Void)
    func getSentRequests(callback: @escaping (ServiceResult<[Contact.Request]>) -> Void)
    func revokeSentRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void)
    func acceptPendingRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void)
    func ignorePendingRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void)
}

class ContactRemoteServiceProvider: ContactRemoteService {
    
    var contactsQuery: ContactsRemoteQuery
    var contactWriter: ContactRemoteWriter
    var contactRequestsQuery: ContactRequestsRemoteQuery
    
    init(contactsQuery: ContactsRemoteQuery = ContactsRemoteQueryProvider(), contactWriter: ContactRemoteWriter = ContactRemoteWriterProvider(), contactRequestsQuery: ContactRequestsRemoteQuery = ContactRequestsRemoteQueryProvider()) {
        self.contactsQuery = contactsQuery
        self.contactWriter = contactWriter
        self.contactRequestsQuery = contactRequestsQuery
    }
    
    func getContacts(callback: @escaping (ServiceResult<[Contact]>) -> Void) {
        contactsQuery.getContacts { [weak self] contacts in
            self?.processQueryRequest(contacts, "no contacts", callback)
        }
    }
    
    func searchPersonsToAdd(with keyword: String, callback: @escaping (ServiceResult<[Person]>) -> Void) {
        contactsQuery.searchPersonsToAdd(with: keyword) { [weak self] persons in
            self?.processQueryRequest(persons, "no persons found", callback)
        }
    }
    
    func sendContactRequest(to personID: String, message: String, callback: @escaping (ServiceResult<String>) -> Void) {
        contactWriter.sendContactRequest(to: personID, message: message) { [weak self] error in
            self?.processWriteRequest("OK", error, callback)
        }
    }
    
    func getSentRequests(callback: @escaping (ServiceResult<[Contact.Request]>) -> Void) {
        contactRequestsQuery.getSentRequests { [weak self] requests in
            self?.processQueryRequest(requests, "no sent requests", callback)
        }
    }
    
    func revokeSentRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void) {
        contactWriter.revokeSentRequest(withID: id) { [weak self] error in
           self?.processWriteRequest(id, error, callback)
        }
    }
    
    func acceptPendingRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void) {
        contactWriter.acceptPendingRequest(withID: id) { [weak self] error in
           self?.processWriteRequest(id, error, callback)
        }
    }
    
    func ignorePendingRequest(withID id: String, callback: @escaping (ServiceResult<String>) -> Void) {
        contactWriter.ignorePendingRequest(withID: id) { [weak self] error in
            self?.processWriteRequest(id, error, callback)
        }
    }
    
    private func processWriteRequest(_ data: String, _ error: Error?, _ callback: @escaping (ServiceResult<String>) -> Void) {
        guard error == nil else {
            callback(.err(error!))
            return
        }
        
        callback(.ok(data))
    }
    
    private func processQueryRequest<T>(_ data: [T], _ errorMessage: String, _ callback: @escaping (ServiceResult<[T]>) -> Void) {
        guard !data.isEmpty else {
            callback(.err(ServiceError(errorMessage)))
            return
        }
        
        callback(.ok(data))
    }
}
