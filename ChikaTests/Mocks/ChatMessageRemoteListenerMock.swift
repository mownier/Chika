//
//  ChatMessageRemoteListenerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/28/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class RecentMessageRemoteListenerMock: RecentMessageRemoteListener {
    
    func listen(for chatID: String, callback: @escaping (Message) -> Void) -> Bool {
        return true
    }
    
    func unlisten(for chatID: String) -> Bool {
        return true
    }
}

