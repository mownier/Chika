//
//  ContactRequestSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRequestSceneWorker: class {

    func fetchSentRequests()
    func fetchPendingRequests()
    func listenOnContactRequests()
}

protocol ContactRequestSceneWorkerOutput: class {

    func workerDidFetchPendingRequests(_ requests: [Contact.Request])
    func workerDidFetchSentRequests(_ requests: [Contact.Request])
    func workerDidFetchPendingRequestsWithError(_ info: Error)
    func workerDidFetchSentRequestsWithError(_ info: Error)
}

extension ContactRequestScene {
    
    class Worker: ContactRequestSceneWorker {
    
        weak var output: ContactRequestSceneWorkerOutput?
        var service: ContactRemoteService
        
        init(service: ContactRemoteService = ContactRemoteServiceProvider()) {
            self.service = service
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
        
        func fetchPendingRequests() {
            service.getPendingRequests { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchPendingRequestsWithError(info)
                    
                case .ok(let requests):
                    self?.output?.workerDidFetchPendingRequests(requests)
                }
            }
        }
        
        func listenOnContactRequests() {
            
        }
    }
}
