//
//  SignInSceneFlowMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneFlowMock: SignInSceneFlow {

    class Callback {
        
        var goToHome: (() -> Void)?
        var showError: ((Error) -> Void)?
    }
    
    var callback: Callback
    var isShowErrorCalled: Bool
    
    init() {
        self.callback = Callback()
        self.isShowErrorCalled = false
    }
    
    func goToHome() -> Bool {
        callback.goToHome?()
        return true
    }
    
    func showError(_ error: Error) {
        callback.showError?(error)
        isShowErrorCalled = true
    }
}
