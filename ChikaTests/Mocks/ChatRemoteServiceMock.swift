//
//  ChatRemoteServiceMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class ChatRemoteServiceMock: ChatRemoteService {

    var isForcedError: Bool = false
    var chats: [Chat] = []
    
    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void) {
        guard isForcedError else {
            completion(.ok(chats))
            return
        }
        
        let error = ServiceError("ChatRemoteService forced error")
        completion(.err(error))
    }
    
    func getMessages(for chatID: String, offset: String, limit: UInt, completion: @escaping (ServiceResult<[Message]>) -> Void) {
        
    }
}
