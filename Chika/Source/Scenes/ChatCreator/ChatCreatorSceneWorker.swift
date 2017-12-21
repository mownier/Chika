//
//  ChatCreatorSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatCreatorSceneWorker: class {

    func fetchContacts()
    func createChat(withTitle title: String, message: String, participants: [Person])
}

protocol ChatCreatorSceneWorkerOutput: class {

    func workerDidFetch(contacts: [Contact])
    func workerDidFetchWithError(_ error: Error)
    func workerDidCreateChat(_ chat: Chat)
    func workerDidCreateChatWithError(_ error: Error)
}

extension ChatCreatorScene {
    
    class Worker: ChatCreatorSceneWorker {
    
        struct Service {
            
            var contact: ContactRemoteService
            var chat: ChatRemoteService
        }
        
        weak var output: ChatCreatorSceneWorkerOutput?
        var service: Service
        
        init(service: Service) {
            self.service = service
        }
        
        convenience init() {
            let contact = ContactRemoteServiceProvider()
            let chat = ChatRemoteServiceProvider()
            let service = Service(contact: contact, chat: chat)
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
        
        func createChat(withTitle title: String, message: String, participants: [Person]) {
            if title.isEmpty && message.isEmpty {
                output?.workerDidCreateChatWithError(AppError("Chat title and short message are empty"))
                return
            }
            
            if title.isEmpty {
                output?.workerDidCreateChatWithError(AppError("Chat title is empty"))
                return
            }
            
            if message.isEmpty {
                output?.workerDidCreateChatWithError(AppError("Short message is empty"))
                return
            }
            
            service.chat.create(withTitle: title, message: message, participantIDs: participants.map({ $0.id })) { [weak self] result in
                dump(result)
                switch result {
                case .err(let info):
                    self?.output?.workerDidCreateChatWithError(info)
                
                case .ok(let chat):
                    self?.output?.workerDidCreateChat(chat)
                }
            }
        }
    }
}
