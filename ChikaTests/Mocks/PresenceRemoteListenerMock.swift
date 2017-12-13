//
//  PresenceRemoteListenerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PresenceRemoteListenerMock: PresenceRemoteListener {

    func listen(personID: String, callback: @escaping (Bool) -> Void) -> Bool {
        return true
    }
    
    func unlisten(personID: String) -> Bool {
        return true
    }
    
    func unlistenAll() -> Bool {
        return true
    }
}
