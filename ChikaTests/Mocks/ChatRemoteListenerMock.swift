//
//  ChatRemoteListenerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class ChatRemoteListenerMock: ChatRemoteListener {
 
    func listenOnTitleUpdate(for chatID: String, callback: @escaping (RemoteListenerResult<(String, String)>) -> Void) -> Bool {
        return true
    }
    
    func removeAllTitleUpdateListeners() -> Bool {
        return true
    }
    
    func unlisteOnTitleUpdate(for chatID: String) -> Bool {
        return true
    }
}
