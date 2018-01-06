//
//  SignInWorkerOutputMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneWorkerOutputMock: SignInSceneWorkerOutput {
    
    let exp: XCTestExpectation
    
    var ok: (() -> Void)?
    var err: ((Error) -> Void)?
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    
    func workerDidSignInWithError(_ error: Swift.Error) {
        err?(error)
        exp.fulfill()
    }
    
    func workerDidSignInOK() {
        ok?()
        exp.fulfill()
    }
}
