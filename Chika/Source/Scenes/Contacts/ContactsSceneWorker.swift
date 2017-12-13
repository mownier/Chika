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
}

protocol ContactsSceneWorkerOutput: class {
    
    func workerDidFetch(contacts: [Contact])
    func workerDidFetchWithError(_ error: Error)
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool)
    func workerDidAddContact(_ contact: Contact)
    func workerDidRemoveContact(_ personID: String)
}

extension ContactsScene {
    
    class Worker: ContactsSceneWorker {
        
        struct Listener {
            
            var presence: PresenceRemoteListener
            var contact: ContactRemoteListener
        }
        
        struct Service {
        
            var search: SearchRemoteService
            var contact: ContactRemoteService
        }
        
        weak var output: ContactsSceneWorkerOutput?
        var service: Service
        var listener: Listener
        
        init(service: Service, listener: Listener) {
            self.service = service
            self.listener = listener
        }
        
        convenience init() {
            let contactService = ContactRemoteServiceProvider()
            let search = SearchRemoteServiceProvider()
            let service = Service(search: search, contact: contactService)
            let presence = PresenceRemoteListenerProvider()
            let contact = ContactRemoteListenerProvider()
            let listener = Listener(presence: presence, contact: contact)
            self.init(service: service, listener: listener)
        }
        
        func fetchContacts() {
            service.contact.getContacts { [weak self] result in
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
            let _ = listener.contact.listenOnAddedContact { [weak self] contact in
                self?.output?.workerDidAddContact(contact)
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
    }
}
