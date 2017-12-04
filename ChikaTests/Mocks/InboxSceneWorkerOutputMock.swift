//
//  InboxSceneWorkerOutputMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class InboxSceneWorkerOutputMock: InboxSceneWorkerOutput {

    var chats: [Chat]? = nil
    var error: Error? = nil
    
    func workerDidFetch(chats: [Chat]) {
        self.chats = chats
    }
    
    func workerDidFetchWithError(_ error: Error) {
        self.error = error
    }
    
    func workerDidReceiveRecentChat(_ chat: Chat) {
        
    }
    
    func workerDidChangeActiveStatus(for participantID: String, isActive: Bool) {
        
    }
    
    func workerDidChangeTypingStatus(for chatID: String, participantID: String, isTyping: Bool) {
        
    }
}
