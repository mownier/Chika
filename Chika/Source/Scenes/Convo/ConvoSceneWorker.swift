//
//  ConvoSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol ConvoSceneWorker: class {

    func fetchNewMessages() -> Bool
    func fetchNextMessages() -> Bool
    func sendMessage(_ content: String) -> Bool
    func listenOnPresence()
    func listenOnRecentMessage()
    func listenOnTypingStatus()
    func unlistenOnTypingStatus()
    func unlisteOnRecentMessage()
    func unlistenOnPresence()
    func changeTypingStatus(_ status: Bool)
}

protocol ConvoSceneWorkerOutput: class {
    
    func workerDidFetchNew(messages: [Message])
    func workerDidFetchNext(messages: [Message])
    func workerDidFetchWithError(_ error: Swift.Error)
    func workerDidSend(message: Message)
    func workerDidSendWithError(_ error: Swift.Error)
    func workerDidUpdateConvo(message: Message)
    func workerDidUpdateTypingStatus(for personID: String, isTyping: Bool)
    func workerDidChangePresence(_ presence: Presence)
}

extension ConvoScene {
    
    class Worker: ConvoSceneWorker {
        
        struct Listener {
            
            var recentMessage: RecentMessageRemoteListener
            var typingStatus: TypingStatusRemoteListener
            var presence: PresenceRemoteListener
        }
        
        enum Fetch {
            
            case new, next
        }
        
        weak var output: ConvoSceneWorkerOutput?
        var service: ChatRemoteService
        var writer: TypingStatusRemoteWriter
        var listener: Listener
        var meID: String
        var chatID: String
        var participantIDs: [String]
        var offset: Double?
        var limit: UInt
        var isFetching: Bool
        var isTyping: Bool
        var isChangingTypingStatus: Bool
        
        init(meID: String, chatID: String, participantIDs: [String], service: ChatRemoteService, listener: Listener, writer: TypingStatusRemoteWriter, limit: UInt) {
            self.meID = meID
            self.chatID = chatID
            self.participantIDs = participantIDs
            self.service = service
            self.listener = listener
            self.writer = writer
            self.offset = 0
            self.limit = limit
            self.isFetching = false
            self.isTyping = false
            self.isChangingTypingStatus = false
        }
        
        convenience init(chatID: String, participantIDs: [String]) {
            let service = ChatRemoteServiceProvider()
            let recentMessage = RecentMessageRemoteListenerProvider()
            let typingStatus = TypingStatusRemoteListenerProvider()
            let presence = PresenceRemoteListenerProvider()
            let listener = Listener(recentMessage: recentMessage, typingStatus: typingStatus, presence: presence)
            let writer = TypingStatusRemoteWriterProvider()
            let limit: UInt = 50
            let meID = Auth.auth().currentUser?.uid ?? ""
            self.init(meID: meID, chatID: chatID, participantIDs: participantIDs, service: service, listener: listener, writer: writer, limit: limit)
        }
        
        func listenOnTypingStatus() {
            guard !chatID.isEmpty else {
                return
            }
            
            let _ = listener.typingStatus.listen(for: chatID) { [weak self] personID, isTyping in
                self?.output?.workerDidUpdateTypingStatus(for: personID, isTyping: isTyping)
            }
        }
        
        func unlistenOnTypingStatus() {
            guard !chatID.isEmpty else {
                return
            }
            
            let _ = listener.typingStatus.unlisten(for: chatID)
        }
        
        func listenOnRecentMessage() {
            guard !chatID.isEmpty else {
                return
            }
            
            let _ = listener.recentMessage.listen(for: chatID) { [weak self] message in
                self?.output?.workerDidUpdateConvo(message: message)
            }
        }
        
        func unlisteOnRecentMessage() {
            guard !chatID.isEmpty else {
                return
            }
            
            let _ = listener.recentMessage.unlisten(for: chatID)
        }
        
        func listenOnPresence() {
            guard participantIDs.count == 2, let personID = participantIDs.filter({ $0 != meID }).first else {
                return
            }
            
            let _ = listener.presence.listen(personID: personID) { [weak self] presence in
                self?.output?.workerDidChangePresence(presence)
            }
        }
        
        func unlistenOnPresence() {
            let _ = listener.presence.unlistenAll()
        }
        
        func changeTypingStatus(_ status: Bool) {
            guard !chatID.isEmpty, !isChangingTypingStatus, isTyping != status else {
                return
            }
            
            isChangingTypingStatus = true
            writer.changeTypingStatus(status, for: chatID) { [weak self] result in
                switch result {
                case .ok:
                    self?.isTyping = status
                
                default:
                    break
                }
                self?.isChangingTypingStatus = false
            }
        }
        
        func sendMessage(_ content: String) -> Bool {
            guard !content.isEmpty else {
                return false
            }
            
            service.writeMessage(for: chatID, participantIDs: participantIDs, content: content) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSendWithError(info)
                
                case .ok(let message):
                    self?.output?.workerDidSend(message: message)
                }
            }
            
            return true
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
                offset = 0
            
            case .next:
                if offset == nil {
                    return false
                }
            }
            
            isFetching = true
            service.getMessages(for: chatID, offset: offset!, limit: limit) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchWithError(info)
                    self?.isFetching = false
                    
                case .ok(let (messages, nextOffset)):
                    let currentOffset = self?.offset
                    self?.offset = nextOffset
                    
                    guard currentOffset != nil, currentOffset! > 0 else {
                        self?.output?.workerDidFetchNew(messages: messages)
                        self?.isFetching = false
                        return
                    }
                    
                    self?.output?.workerDidFetchNext(messages: messages)
                    self?.isFetching = false
                }
            }
            
            return true
        }
    }
}
