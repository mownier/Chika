//
//  ContactRequestSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRequestSceneWorker: class {

    func fetchSentRequests()
    func listenOnContactRequests()
    func unlistenOnContactRequests()
    func revokeSentRequest(withID id: String)
    func ignorePendingRequest(withID id: String)
    func acceptPendingRequest(withID id: String)
}

protocol ContactRequestSceneWorkerOutput: class {

    func workerDidFetchSentRequests(_ requests: [Contact.Request])
    func workerDidFetchSentRequestsWithError(_ info: Error)
    func workerDidReceiveContactRequest(_ request: Contact.Request)
    func workerDidRevokeSentRequest(withID id: String)
    func workerDidIgnorePendingRequest(withID id: String)
    func workerDidAcceptPendingRequest(withID id: String)
    func workerDidRevokeSentRequest(withError error: Error, id: String)
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
        
        func fetchSentRequests() {
            service.getSentRequests { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchSentRequestsWithError(info)
                
                case .ok(let requests):
                    self?.output?.workerDidFetchSentRequests(requests)
                }
            }
        }
        
        func listenOnContactRequests() {
            let _ = listener.listen { [weak self] request in
                self?.output?.workerDidReceiveContactRequest(request)
            }
        }
        
        func unlistenOnContactRequests() {
            let _ = listener.unlisten()
        }
        
        func revokeSentRequest(withID id: String) {
            service.revokeSentRequest(withID: id) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidRevokeSentRequest(withError: info, id: id)
                
                case .ok(let id):
                    self?.output?.workerDidRevokeSentRequest(withID: id)
                }
            }
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
