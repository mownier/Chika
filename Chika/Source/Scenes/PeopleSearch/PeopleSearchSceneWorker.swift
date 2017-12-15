//
//  PeopleSearchSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol PeopleSearchSceneWorker: class {

    func listenOnActiveStatus(for personIDs: [String])
    func listenOnAddedContact()
    func listenOnRemovedContact()
    func listenOnReceivedContactRequest()
    func listenOnIgnoredContactRequest()
    func unlistenOnActiveStatus(for personIDs: [String])
    func unlistenAll()
    func searchPeople(withKeyword keyword: String?)
    func sendContactRequest(to personID: String, message: String)
}

protocol PeopleSearchSceneWorkerOutput: class {

    func workerDidChangeActiveStatus(for personID: String, isActive: Bool)
    func workerDidRequestContactWithError(_ error: Error, personID: String)
    func workerDidRequestContactOK(_ personID: String)
    func workerDidSearchPeopleWithObjects(_ objects: [PersonSearchObject])
    func workerDidSearchPeopleWithError(_ error: Error)
    func workerDidAddContact(person: Person, chat: Chat)
    func workerDidRemoveContact(withPersonID: String)
    func workerDidReceiveContactRequest(from personID: String)
    func workerDidIgnoreContactRequest(by personID: String)
}

extension PeopleSearchScene {
    
    class Worker: PeopleSearchSceneWorker {
    
        struct Listener {
            
            var presence: PresenceRemoteListener
            var contact: ContactRemoteListener
            var request: ContactRequestRemoteListener
        }
        
        struct Service {
            
            var search: SearchRemoteService
            var contact: ContactRemoteService
        }
        
        weak var output: PeopleSearchSceneWorkerOutput?
        var listener: Listener
        var service: Service
        
        init(listener: Listener, service: Service) {
            self.listener = listener
            self.service = service
        }
        
        convenience init() {
            let request = ContactRequestRemoteListenerProvider()
            let contactListener = ContactRemoteListenerProvider()
            let presence = PresenceRemoteListenerProvider()
            let search = SearchRemoteServiceProvider()
            let contact = ContactRemoteServiceProvider()
            let listener = Listener(presence: presence, contact: contactListener, request: request)
            let service = Service(search: search, contact: contact)
            self.init(listener: listener, service: service)
        }
        
        func listenOnActiveStatus(for personIDs: [String]) {
            for personID in personIDs {
                let _ = listener.presence.listen(personID: personID) { [weak self] presence in
                    self?.output?.workerDidChangeActiveStatus(for: personID, isActive: presence.isActive)
                }
            }
        }
        
        func listenOnAddedContact() {
            let _ = listener.contact.listenOnAddedContact { [weak self] contact in
                self?.output?.workerDidAddContact(person: contact.person, chat: contact.chat)
            }
        }
        
        func listenOnRemovedContact() {
            let _ = listener.contact.listenOnRemovedContact { [weak self] personID in
                self?.output?.workerDidRemoveContact(withPersonID: personID)
            }
        }
        
        func listenOnReceivedContactRequest() {
            let _ = listener.request.listenOnAdded { [weak self] request in
                self?.output?.workerDidReceiveContactRequest(from: request.requestee.id)
            }
        }
        
        func listenOnIgnoredContactRequest() {
            let _ = listener.request.listenOnRemoved { [weak self] request in
                self?.output?.workerDidIgnoreContactRequest(by: request.requestee.id)
            }
        }
        
        func unlistenOnActiveStatus(for personIDs: [String]) {
            for personID in personIDs {
                let _ = listener.presence.unlisten(personID: personID)
            }
        }
        
        func unlistenAll() {
            let _ = listener.presence.unlistenAll()
            let _ = listener.contact.unlistenOnRemovedContact()
            let _ = listener.contact.unlistenOnAddedConctact()
            let _ = listener.request.unlistenOnAdded()
            let _ = listener.request.unlistenOnRemoved()
        }
        
        func searchPeople(withKeyword keyword: String?) {
            guard let keyword = keyword, !keyword.isEmpty else {
                let error = AppError("no search keyword")
                output?.workerDidSearchPeopleWithError(error)
                return
            }
            
            service.search.searchPeople(withKeyword: keyword) { [weak self] result in
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
