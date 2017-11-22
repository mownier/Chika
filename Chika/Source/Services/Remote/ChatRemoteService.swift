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
}

class ChatRemoteServiceProvider: ChatRemoteService {
    
    var inboxQuery: InboxRemoteQuery
    
    init(inboxQuery: InboxRemoteQuery = InboxRemoteQueryProvider()) {
        self.inboxQuery = inboxQuery
    }
    
    func getInbox(for userID: String, completion: @escaping (ServiceResult<[Chat]>) -> Void) {
        inboxQuery.getInbox(for: userID) { chats in
            guard !chats.isEmpty else {
                completion(.err(ServiceError("inbox is empty")))
                return
            }
            
            completion(.ok(chats.reversed()))
        }
    }
}
