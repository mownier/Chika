//
//  InitialSceneFlowMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class InitialSceneFlowMock: InitialSceneFlow {

    var isGoToSignInCalled: Bool = false
    var isGoToRegisterCalled: Bool = false
    
    func goToSignIn() -> Bool {
        isGoToSignInCalled = true
        return true
    }
    
    func goToRegister() -> Bool {
        isGoToRegisterCalled = true
        return true
    }
}
