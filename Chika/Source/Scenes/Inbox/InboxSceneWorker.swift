//
//  InboxSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol InboxSceneWorker: class {

    func listenOnRecentChat()
    func listenOnActiveStatus(for chat: Chat?)
    func listenOnTypingStatus(for chat: Chat?)
    func unlistenOnRecentChat()
    func unlistenOnActiveStatus(for chat: Chat?)
    func unlistenOnTypingStatus(for chat: Chat?)
    func fetchInbox()
}

protocol InboxSceneWorkerOutput: class {
    
    func workerDidFetch(chats: [Chat])
    func workerDidFetchWithError(_ error: Error)
    func workerDidReceiveRecentChat(_ chat: Chat)
    func workerDidChangeActiveStatus(for participantID: String, isActive: Bool)
    func workerDidChangeTypingStatus(for chatID: String, participantID: String, isTyping: Bool)
}

extension InboxScene {
    
    class Worker: InboxSceneWorker {
        
        struct Listener {
            
            var recentChat: RecentChatRemoteListener
            var presence: PresenceRemoteListener
            var typingStatus: TypingStatusRemoteListener
        }
        
        weak var output: InboxSceneWorkerOutput?
        var meID: String
        var service: ChatRemoteService
        var listener: Listener
        
        init(meID: String, service: ChatRemoteService, listener: Listener) {
            self.meID = meID
            self.service = service
            self.listener = listener
        }
        
        convenience init(meID: String = Auth.auth().currentUser?.uid ?? "") {
            let service = ChatRemoteServiceProvider()
            let recentChat = RecentChatRemoteListenerProvider(meID: meID)
            let presence = PresenceRemoteListenerProvider()
            let typingStatus = TypingStatusRemoteListenerProvider()
            let listener = Listener(recentChat: recentChat, presence: presence, typingStatus: typingStatus)
            self.init(meID: meID, service: service, listener: listener)
        }
        
        func fetchInbox() {
            service.getInbox(for: meID) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchWithError(info)
                
                case .ok(let chats):
                    self?.output?.workerDidFetch(chats: chats)
                }
            }
        }
        
        func listenOnRecentChat() {
            let _ = listener.recentChat.listen { [weak self] chat in
                self?.output?.workerDidReceiveRecentChat(chat)
            }
        }
        
        func listenOnActiveStatus(for chat: Chat?) {
            guard chat != nil, !chat!.participants.isEmpty else {
                return
            }
            
            for participant in chat!.participants {
                let _ = listener.presence.listen(personID: participant.id) { [weak self] isActive in
                    self?.output?.workerDidChangeActiveStatus(for: participant.id, isActive: isActive)
                }
            }
        }
        
        func listenOnTypingStatus(for chat: Chat?) {
            guard let chat = chat else {
                return
            }
            
            let _ = listener.typingStatus.listen(for: chat.id) { [weak self] personID, isTyping in
                self?.output?.workerDidChangeTypingStatus(for: chat.id, participantID: personID, isTyping: isTyping)
            }
        }
        
        func unlistenOnRecentChat() {
            let _ = listener.recentChat.unlisten()
        }
        
        func unlistenOnActiveStatus(for chat: Chat?) {
            guard chat != nil, !chat!.participants.isEmpty else {
                return
            }
            
            for participant in chat!.participants {
                let _ = listener.presence.unlisten(personID: participant.id)
            }
        }
        
        func unlistenOnTypingStatus(for chat: Chat?) {
            guard let chat = chat else {
                return
            }
            
            let _ = listener.typingStatus.unlisten(for: chat.id)
        }
    }
}
