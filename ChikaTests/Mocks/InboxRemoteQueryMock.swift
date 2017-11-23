//
//  InboxRemoteQueryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class InboxRemoteQueryMock: InboxRemoteQuery {

    var mockChats: [Chat] = []
    
    func getInbox(for personID: String, completion: @escaping ([Chat]) -> Void) {
        completion(mockChats)
    }
}
