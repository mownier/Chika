//
//  InitialSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneTests: XCTestCase {
    
    // CONTEXT: Constructor should have the default value of
    // theme and flow properties as intance of InitialScene.Theme
    // and InitialScene.Flow respectively
    func testInitA() {
        var scene = InitialScene()
        XCTAssertTrue(scene.theme is InitialScene.Theme)
        XCTAssertTrue(scene.flow is InitialScene.Flow)
        
        scene = InitialScene(coder: NSCoder())!
        XCTAssertTrue(scene.theme is InitialScene.Theme)
        XCTAssertTrue(scene.flow is InitialScene.Flow)
    }
    
    // CONTEXT: didTapSignIn function should call the signIn function
    // in flow given that the signIn button is tapped
    func testDidTapSignInA() {
        let theme = InitialScene.Theme()
        let flow = InitialSceneFlowMock()
        let scene = InitialScene(theme: theme, flow: flow)
        let _ = scene.view
        flow.isGoToSignInCalled = false
        scene.signInButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(flow.isGoToSignInCalled)
    }
    
    // CONTEXT: didTapRegister function should call the register function
    // in flow given that the register button is tapped
    func testDidTapRegisterA() {
        let theme = InitialScene.Theme()
        let flow = InitialSceneFlowMock()
        let scene = InitialScene(theme: theme, flow: flow)
        let _ = scene.view
        flow.isGoToRegisterCalled = false
        scene.registerButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(flow.isGoToRegisterCalled)
    }
}
