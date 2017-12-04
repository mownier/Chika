//
//  RecentChatRemoteListenerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/28/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class RecentChatRemoteListenerMock: RecentChatRemoteListener {
    
    func listen(callback: @escaping (Chat) -> Void) -> Bool {
        return true
    }
    
    func unlisten() -> Bool {
        return true
    }
}
