//
//  RecentMessageRemoteQueryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class RecentMessageRemoteQueryMock: RecentMessageRemoteQuery {

    var mockMessages: [Message?] = []
    
    func getRecentMessage(for chatID: String, completion: @escaping (Message?) -> Void) {
        completion(mockMessages.removeFirst())
    }
}
