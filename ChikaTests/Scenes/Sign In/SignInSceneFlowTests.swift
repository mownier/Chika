//
//  SignInSceneFlowTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneFlowTests: XCTestCase {
    
    // CONTEXT: Constructor should instantiate homeSceneFlow
    // property with default class HomeScene.Flow
    func testInitA() {
        let flow = SignInScene.Flow()
        XCTAssertTrue(flow.homeSceneFlow is HomeScene.Flow)
    }
    
    // CONTEXT: showError function should show an alert
    // controller coming from the error parameter
    func testShowErrorA() {
        let scene = UIViewController()
        let flow = SignInScene.Flow()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let error = AppError("Flow error")
        
        window.rootViewController = scene
        window.makeKeyAndVisible()
        flow.scene = scene
        flow.showError(error)
        
        XCTAssertTrue(scene.presentedViewController is UIAlertController)
        let alert = scene.presentedViewController as! UIAlertController
        XCTAssertEqual(alert.title, "Error")
        XCTAssertEqual(alert.message, "\(error)")
    }
    
    // CONTEXT: goToHome function should not be connected given
    // that scene is nil
    func testGoToHomeA() {
        let homeSceneFlow = HomeSceneFlowMock()
        let flow = SignInScene.Flow(homeSceneFlow: homeSceneFlow)
        let ok = flow.goToHome()
        XCTAssertFalse(ok)
        XCTAssertFalse(homeSceneFlow.isConnected)
    }
    
    // CONTEXT: goToHome function should be connected and the
    // scene should be dismissed given that it is presented
    func testGoToHomeB() {
        let homeSceneFlow = HomeSceneFlowMock()
        let flow = SignInScene.Flow(homeSceneFlow: homeSceneFlow)
        let scene = SignInSceneMock()
        scene.isPresented = true
        flow.scene = scene
        let ok = flow.goToHome()
        XCTAssertTrue(ok)
        XCTAssertTrue(homeSceneFlow.isConnected)
        XCTAssertFalse(scene.isBeingPresented)
    }
}
