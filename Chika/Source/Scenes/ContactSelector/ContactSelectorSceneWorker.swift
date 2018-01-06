//
//  ContactSelectorSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactSelectorSceneWorker: class {

    func fetchContacts()
}

protocol ContactSelectorSceneWorkerOutput: class {

    func workerDidFetch(contacts: [Contact])
    func workerDidFetchWithError(_ error: Swift.Error)
}

extension ContactSelectorScene {
    
    class Worker: ContactSelectorSceneWorker {
    
        struct Service {
            
            var contact: ContactRemoteService
        }
        
        weak var output: ContactSelectorSceneWorkerOutput?
        var service: Service
        
        init(service: Service) {
            self.service = service
        }
        
        convenience init() {
            let contact = ContactRemoteServiceProvider()
            let service = Service(contact: contact)
            self.init(service: service)
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
    }
}
