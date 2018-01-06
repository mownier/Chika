//
//  PresenceRemoteWriterMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PresenceRemoteWriterMock: PresenceRemoteWriter {

    var hasError: Bool = false
    
    func makeOnline(callback: @escaping (RemoteWriterResult<String>) -> Void) {
        guard !hasError else {
            callback(.err(Error("forced error")))
            return
        }
        
        callback(.ok("OK"))
    }
    
    func makeOffline(callback: @escaping (RemoteWriterResult<String>) -> Void) {
        guard !hasError else {
            callback(.err(Error("forced error")))
            return
        }
        
        callback(.ok("OK"))
    }
}
