//
//  PresenceRemoteWriterFactoryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PresenceRemoteWriterFactoryMock: PresenceRemoteWriterFactory {

    var hasError: Bool = false
    
    func build() -> PresenceRemoteWriter {
        let mock = PresenceRemoteWriterMock()
        mock.hasError = hasError
        return mock
    }
}
