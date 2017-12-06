//
//  ContactsSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactsSceneWorker: class {

    func fetchContacts()
    func listenOnActiveStatus(for personID: String)
    func listenOnAddedContact()
    func listenOnRemovedContact()
    func unlistenOnActiveStatus(for personID: String)
    func searchPersonsToAdd(with keyword: String?)
}

protocol ContactsSceneWorkerOutput: class {
    
    func workerDidFetch(contacts: [Person])
    func workerDidFetchWithError(_ error: Error)
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool)
    func workerDidAddContact(_ contact: Person)
    func workerDidRemoveContact(_ personID: String)
    func workerDidSearchPersonsToAdd(persons: [Person])
    func workerDidSearchPersonsToAddWithError(_ error: Error)
}

extension ContactsScene {
    
    class Worker: ContactsSceneWorker {
        
        struct Listener {
            
            var presence: PresenceRemoteListener
            var contact: ContactRemoteListener
        }
        
        weak var output: ContactsSceneWorkerOutput?
        var contactService: ContactRemoteService
        var listener: Listener
        
        init(contactService: ContactRemoteService, listener: Listener) {
            self.contactService = contactService
            self.listener = listener
        }
        
        convenience init() {
            let contactService = ContactRemoteServiceProvider()
            let presence = PresenceRemoteListenerProvider()
            let contact = ContactRemoteListenerProvider()
            let listener = Listener(presence: presence, contact: contact)
            self.init(contactService: contactService, listener: listener)
        }
        
        func fetchContacts() {
            contactService.getContacts { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchWithError(info)
                
                case .ok(let contacts):
                    self?.output?.workerDidFetch(contacts: contacts)
                }
            }
        }
        
        func listenOnActiveStatus(for personID: String) {
            let _ = listener.presence.listen(personID: personID) { [weak self] isActive in
                self?.output?.workerDidChangeActiveStatus(for: personID, isActive: isActive)
            }
        }
        
        func listenOnAddedContact() {
            let _ = listener.contact.listenOnAddedContact { [weak self] person in
                self?.output?.workerDidAddContact(person)
            }
        }
        
        func listenOnRemovedContact() {
            let _ = listener.contact.listenOnRemovedContact { [weak self] personID in
                self?.output?.workerDidRemoveContact(personID)
            }
        }
        
        func unlistenOnActiveStatus(for personID: String) {
            let _ = listener.presence.unlisten(personID: personID)
        }
        
        func searchPersonsToAdd(with keyword: String?) {
            guard keyword != nil else {
                let error = AppError("search keyword is nil")
                output?.workerDidSearchPersonsToAddWithError(error)
                return
            }
            
            contactService.searchPersonsToAdd(with: keyword!) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSearchPersonsToAddWithError(info)
                    
                case .ok(let persons):
                    self?.output?.workerDidSearchPersonsToAdd(persons: persons)
                }
            }
        }
    }
}
