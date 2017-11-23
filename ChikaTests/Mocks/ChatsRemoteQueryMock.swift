//
//  ChatsRemoteQueryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
@testable import Chika

class ChatsRemoteQueryMock: ChatsRemoteQuery {

    var mockChats: [String: Chat] = [:]
    var sort = ChatsSortProvider()
    
    func getChats(for keys: [String], completion: @escaping ([Chat]) -> Void) {
        var chats = mockChats.flatMap({ $0.value }).filter({ keys.contains($0.id) })
        sort.by(keys, &chats)
        completion(chats)
    }
}
