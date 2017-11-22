//
//  InboxSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol InboxSceneWorker: class {

    func fetchInbox()
}

protocol InboxSceneWorkerOutput: class {
    
    func workerDidFetch(chats: [Chat])
    func workerDidFetchWithError(_ error: Error)
}

extension InboxScene {
    
    class Worker: InboxSceneWorker {
        
        weak var output: InboxSceneWorkerOutput?
        var personID: String
        var service: ChatRemoteService
        
        init(personID: String, service: ChatRemoteService) {
            self.personID = personID
            self.service = service
        }
        
        convenience init(user: User? = Auth.auth().currentUser) {
            let personID = user?.uid ?? ""
            let service = ChatRemoteServiceProvider()
            self.init(personID: personID, service: service)
        }
        
        func fetchInbox() {
            service.getInbox(for: personID) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchWithError(info)
                
                case .ok(let chats):
                    self?.output?.workerDidFetch(chats: chats)
                }
            }
        }
    }
}
