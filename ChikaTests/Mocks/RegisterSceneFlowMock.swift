//
//  RegisterSceneFlowMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneFlowMock: RegisterSceneFlow {

    class Callback {
        
        var goToHome: (() -> Void)?
        var showError: ((Error) -> Void)?
    }
    
    var isShowErrorCalled: Bool
    var callback: Callback
    
    init() {
        self.callback = Callback()
        self.isShowErrorCalled = false
    }
    
    func goToHome() -> Bool {
        callback.goToHome?()
        return true
    }
    
    func showError(_ error: Swift.Error) {
        callback.showError?(error)
        isShowErrorCalled = true
    }
}
