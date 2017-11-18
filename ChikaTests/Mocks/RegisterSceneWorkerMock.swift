//
//  RegisterSceneWorkerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneWorkerMock: RegisterScene.Worker {

    class Callback {
        
        var workerDidRegisterOK: (() -> Void)?
        var workerDidRegisterWithError: ((Error) -> Void)?
    }
    
    var isOK: Bool = true
    var exp: XCTestExpectation?
    var callback: Callback = Callback()
    
    override func register(email: String?, pass: String?) {
        if isOK {
            output?.workerDidRegisterOK()
            callback.workerDidRegisterOK?()
            
        } else {
            let error = AppError("Worker sign in failed")
            output?.workerDidRegisterWithError(error)
            callback.workerDidRegisterWithError?(error)
        }
        
        exp?.fulfill()
    }
}
