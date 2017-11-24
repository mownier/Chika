//
//  ConvoSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ConvoSceneWorker: class {

    func fetchNewMessages() -> Bool
    func fetchNextMessages() -> Bool
}

protocol ConvoSceneWorkerOutput: class {
    
    func workerDidFetchNew(messages: [Message])
    func workerDidFetchNext(messages: [Message])
    func workerDidFetchWithError(_ error: Error)
}

extension ConvoScene {
    
    class Worker: ConvoSceneWorker {
        
        enum Fetch {
            
            case new, next
        }
        
        weak var output: ConvoSceneWorkerOutput?
        var service: ChatRemoteService
        var chatID: String
        var offset: String
        var limit: UInt
        var isFetching: Bool
        
        init(chatID: String, service: ChatRemoteService, limit: UInt) {
            self.chatID = chatID
            self.service = service
            self.offset = ""
            self.limit = limit
            self.isFetching = false
        }
        
        convenience init(chatID: String) {
            let service = ChatRemoteServiceProvider()
            let limit: UInt = 50
            self.init(chatID: chatID, service: service, limit: limit)
        }
        
        func fetchNewMessages() -> Bool {
            return fetchMessages(.new)
        }
        
        func fetchNextMessages() -> Bool {
            return fetchMessages(.next)
        }
        
        private func fetchMessages(_ fetch: Fetch) -> Bool {
            guard !isFetching else {
                return false
            }
            
            switch fetch {
            case .new:
                offset = ""
            
            default:
                break
            }
            
            service.getMessages(for: chatID, offset: offset, limit: limit) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchWithError(info)
                    
                case .ok(let messages):
                    guard let offset = self?.offset, !offset.isEmpty else {
                        self?.output?.workerDidFetchNew(messages: messages)
                        return
                    }
                    
                    self?.output?.workerDidFetchNext(messages: messages)
                }
            }
            
            return true
        }
    }
}
