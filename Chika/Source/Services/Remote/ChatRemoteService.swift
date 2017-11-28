//
//  ChatRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatRemoteService: class {

    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void)
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping (ServiceResult<([Message], Double?)>) -> Void)
    func writeMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (ServiceResult<Message>) -> Void)
}

class ChatRemoteServiceProvider: ChatRemoteService {
    
    var inboxQuery: InboxRemoteQuery
    var chatMessagesQuery: ChatMessagesRemoteQuery
    var messageWriter: MessageRemoteWriter
    
    init(inboxQuery: InboxRemoteQuery = InboxRemoteQueryProvider(), chatMessagesQuery: ChatMessagesRemoteQuery = ChatMessagesRemoteQueryProvider(), messageWriter: MessageRemoteWriter = MessageRemoteWriterProvider()) {
        self.inboxQuery = inboxQuery
        self.chatMessagesQuery = chatMessagesQuery
        self.messageWriter = messageWriter
    }
    
    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void) {
        inboxQuery.getInbox(for: userID) { chats in
            guard !chats.isEmpty else {
                completion(.err(ServiceError("can not get inbox")))
                return
            }
            
            completion(.ok(chats.reversed()))
        }
    }
    
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping (ServiceResult<([Message], Double?)>) -> Void) {
        chatMessagesQuery.getMessages(for: chatID, offset: offset, limit: limit) { messages, nextOffset in
            guard !messages.isEmpty else {
                completion(.err(ServiceError("no chat messages")))
                return
            }
            
            completion(.ok((messages, nextOffset)))
        }
    }
    
    func writeMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (ServiceResult<Message>) -> Void) {
        messageWriter.postMessage(for: chatID, participantIDs: participantIDs, content: content) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok(let message):
                completion(.ok(message))
            }
        }
    }
}
