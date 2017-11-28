//
//  InboxSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol InboxSceneWorker: class {

    func listenForInboxUpdates()
    func fetchInbox()
}

protocol InboxSceneWorkerOutput: class {
    
    func workerDidFetch(chats: [Chat])
    func workerDidFetchWithError(_ error: Error)
    func workerDidUpdateInbox(chat: Chat)
}

extension InboxScene {
    
    class Worker: InboxSceneWorker {
        
        weak var output: InboxSceneWorkerOutput?
        var personID: String
        var service: ChatRemoteService
        var listener: InboxRemoteListener
        
        init(personID: String, service: ChatRemoteService, listener: InboxRemoteListener) {
            self.personID = personID
            self.service = service
            self.listener = listener
        }
        
        convenience init(user: User? = Auth.auth().currentUser) {
            let personID = user?.uid ?? ""
            let service = ChatRemoteServiceProvider()
            let listener = InboxRemoteListenerProvider(personID: personID)
            self.init(personID: personID, service: service, listener: listener)
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
        
        func listenForInboxUpdates() {
            listener.listen { [weak self] chat in
                self?.output?.workerDidUpdateInbox(chat: chat)
            }
        }
    }
}
