//
//  ChatRemoteServiceMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika
import TNCore

class ChatRemoteServiceMock: ChatRemoteService {

    var isForcedError: Bool = false
    var chats: [Chat] = []
    
    func getInbox(for userID: String, completion: @escaping (Result<[Chat]>) -> Void) {
        guard isForcedError else {
            completion(.ok(chats))
            return
        }
        
        let error = Error("ChatRemoteService forced error")
        completion(.err(error))
    }
    
    func getMessages(for chatID: String, offset: Double, limit: UInt, completion: @escaping (Result<([Message], Double?)>) -> Void) {
        
    }
    
    func writeMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (Result<Message>) -> Void) {
        
    }
    
    func create(withTitle title: String, message: String, participantIDs: [String], completion: @escaping (Result<Chat>) -> Void) {
        
    }
}
