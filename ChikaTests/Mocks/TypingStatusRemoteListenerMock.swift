//
//  TypingStatusRemoteListenerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class TypingStatusRemoteListenerMock: TypingStatusRemoteListener {

    func listen(for chatID: String, callback: @escaping (String, Bool) -> Void) -> Bool {
        return true
    }
    
    func unlisten(for chatID: String) -> Bool {
        return true
    }
}
