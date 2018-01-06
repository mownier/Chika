//
//  ChatRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import TNCore

protocol ChatRemoteService: class {

    func getInbox(for userID: String, completion: @escaping (Result<[Chat]>) -> Void)
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping (Result<([Message], Double?)>) -> Void)
    func writeMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (Result<Message>) -> Void)
    func create(withTitle title: String, message: String, participantIDs: [String], completion: @escaping (Result<Chat>) -> Void)
}

class ChatRemoteServiceProvider: ChatRemoteService {
    
    var inboxQuery: InboxRemoteQuery
    var chatMessagesQuery: ChatMessagesRemoteQuery
    var messageWriter: MessageRemoteWriter
    var chatWriter: ChatRemoteWriter
    
    init(inboxQuery: InboxRemoteQuery = InboxRemoteQueryProvider(), chatMessagesQuery: ChatMessagesRemoteQuery = ChatMessagesRemoteQueryProvider(), messageWriter: MessageRemoteWriter = MessageRemoteWriterProvider(), chatWriter: ChatRemoteWriter = ChatRemoteWriterProvider()) {
        self.inboxQuery = inboxQuery
        self.chatMessagesQuery = chatMessagesQuery
        self.messageWriter = messageWriter
        self.chatWriter = chatWriter
    }
    
    func getInbox(for userID: String, completion: @escaping (Result<[Chat]>) -> Void) {
        inboxQuery.getInbox(for: userID) { chats in
            guard !chats.isEmpty else {
                completion(.err(Error("can not get inbox")))
                return
            }
            
            completion(.ok(chats.sorted(by: { $0.recent.date.timeIntervalSince1970 > $1.recent.date.timeIntervalSince1970 })))
        }
    }
    
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping (Result<([Message], Double?)>) -> Void) {
        chatMessagesQuery.getMessages(for: chatID, offset: offset, limit: limit) { messages, nextOffset in
            guard !messages.isEmpty else {
                completion(.err(Error("no chat messages")))
                return
            }
            
            completion(.ok((messages, nextOffset)))
        }
    }
    
    func writeMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (Result<Message>) -> Void) {
        messageWriter.postMessage(for: chatID, participantIDs: participantIDs, content: content) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok(let message):
                completion(.ok(message))
            }
        }
    }
    
    func create(withTitle title: String, message: String, participantIDs: [String], completion: @escaping (Result<Chat>) -> Void) {
        chatWriter.create(withTitle: title, message: message, participantIDs: participantIDs) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok(let chat):
                completion(.ok(chat))
            }
        }
    }
}
