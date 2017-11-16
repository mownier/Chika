//
//  SignInSceneWorkerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneWorkerMock: SignInScene.Worker {

    class Callback {
        
        var workerDidSignInOK: (() -> Void)?
        var workerDidSignInWithError: ((Error) -> Void)?
    }
    
    var isOK: Bool = true
    var exp: XCTestExpectation?
    var callback: Callback = Callback()
    
    override func signIn(email: String?, pass: String?) {
        if isOK {
            output?.workerDidSignInOK()
            callback.workerDidSignInOK?()
        
        } else {
            let error = AppError("Worker sign in failed")
            output?.workerDidSignInWithError(error)
            callback.workerDidSignInWithError?(error)
        }
        
        exp?.fulfill()
    }
}
