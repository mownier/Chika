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
    func searchPeople(withKeyword keyword: String?)
    func sendContactRequest(to personID: String, message: String)
}

protocol ContactsSceneWorkerOutput: class {
    
    func workerDidFetch(contacts: [Contact])
    func workerDidFetchWithError(_ error: Error)
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool)
    func workerDidAddContact(_ contact: Contact)
    func workerDidRequestContactWithError(_ error: Error, personID: String)
    func workerDidRequestContactOK(_ personID: String)
    func workerDidRemoveContact(_ personID: String)
    func workerDidSearchPeopleWithObjects(_ objects: [PersonSearchObject])
    func workerDidSearchPeopleWithError(_ error: Error)
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
        
        func searchPeople(withKeyword keyword: String?) {
            guard keyword != nil else {
                let error = AppError("search keyword is nil")
                output?.workerDidSearchPeopleWithError(error)
                return
            }
            
            service.search.searchPeople(withKeyword: keyword!) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSearchPeopleWithError(info)
                    
                case .ok(let objects):
                    self?.output?.workerDidSearchPeopleWithObjects(objects)
                }
            }
        }
        
        func sendContactRequest(to personID: String, message: String) {
            service.contact.sendContactRequest(to: personID, message: message) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidRequestContactWithError(info, personID: personID)
                    
                case .ok:
                    self?.output?.workerDidRequestContactOK(personID)
                }
            }
        }
    }
}
