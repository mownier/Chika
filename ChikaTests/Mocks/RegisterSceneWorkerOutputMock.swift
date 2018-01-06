//
//  RegisterSceneWorkerOutputMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneWorkerOutputMock: RegisterSceneWorkerOutput {
    
    let exp: XCTestExpectation
    
    var ok: (() -> Void)?
    var err: ((Error) -> Void)?
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    
    func workerDidRegisterWithError(_ error: Swift.Error) {
        err?(error)
        exp.fulfill()
    }
    
    func workerDidRegisterOK() {
        ok?()
        exp.fulfill()
    }
}

