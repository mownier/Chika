//
//  ContactRequestSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRequestSceneWorker: class {

    func listenOnAddedContactRequests()
    func unlistenOnAddedContactRequests()
    func ignorePendingRequest(withID id: String)
    func acceptPendingRequest(withID id: String)
}

protocol ContactRequestSceneWorkerOutput: class {

    func workerDidReceiveContactRequest(_ request: Contact.Request)
    func workerDidIgnorePendingRequest(withID id: String)
    func workerDidAcceptPendingRequest(withID id: String)
    func workerDidIgnorePendingRequest(withError error: Error, id: String)
    func workerDidAcceptPendingRequest(withError error: Error, id: String)
}

extension ContactRequestScene {
    
    class Worker: ContactRequestSceneWorker {
    
        weak var output: ContactRequestSceneWorkerOutput?
        var service: ContactRemoteService
        var listener: ContactRequestRemoteListener
        
        init(service: ContactRemoteService = ContactRemoteServiceProvider(), listener: ContactRequestRemoteListener = ContactRequestRemoteListenerProvider()) {
            self.service = service
            self.listener = listener
        }
        
        func listenOnAddedContactRequests() {
            let _ = listener.listenOnAdded { [weak self] request in
                self?.output?.workerDidReceiveContactRequest(request)
            }
        }
        
        func unlistenOnAddedContactRequests() {
            let _ = listener.unlistenOnAdded()
        }
        
        func acceptPendingRequest(withID id: String) {
            service.acceptPendingRequest(withID: id) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidAcceptPendingRequest(withError: info, id: id)
                    
                case .ok(let id):
                    self?.output?.workerDidAcceptPendingRequest(withID: id)
                }
            }
        }
        
        func ignorePendingRequest(withID id: String) {
            service.ignorePendingRequest(withID: id) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidIgnorePendingRequest(withError: info, id: id)
                    
                case .ok(let id):
                    self?.output?.workerDidIgnorePendingRequest(withID: id)
                }
            }
        }
    }
}
