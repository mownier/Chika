//
//  MessagesRemoteQueryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class MessagesRemoteQueryMock: MessagesRemoteQuery {

    var mockMessages: [Message] = []
    
    func getMessages(for keys: [String], completion: @escaping ([Message]) -> Void) {
        completion(mockMessages)
    }
}
