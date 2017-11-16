//
//  SignInSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneTests: XCTestCase {
    
    // CONTEXT: Convenience init should have the instances
    // of Theme and Worker classes for it's theme and worker
    // properties. The worker's output should be the scene.
    func testInitA() {
        constructorTest()
    }
    
    // CONTEXT: Init with coder should have the instances
    // of Theme and Worker classes for it's theme and worker
    // properties. The worker's output should be the scene.
    func testInitB() {
        constructorTest(withType: "coder")
    }
    
    // CONTEXT: didTapGo function should resign the email and
    // pass inputs as first responder. It should return ok.
    // Texts of inputs should be empty.
    func testDidTapGoA() {
        let exp = expectation(description: "testDidTapGoA")
        let service = AuthRemoteServiceMock()
        let worker = SignInSceneWorkerMock(service: service)
        let theme = SignInScene.Theme()
        let flow = SignInSceneFlowMock()
        let scene = SignInScene(theme: theme, worker: worker, flow: flow)
        let _ = scene.view
        
        worker.exp = exp
        worker.output = scene
        worker.callback.workerDidSignInWithError = { _ in XCTFail() }
        worker.callback.workerDidSignInOK = {
            XCTAssertFalse(scene.emailInput.isFirstResponder)
            XCTAssertFalse(scene.passInput.isFirstResponder)
            XCTAssertTrue(scene.emailInput.text!.isEmpty)
            XCTAssertTrue(scene.passInput.text!.isEmpty)
        }
        
        scene.emailInput.text = "me@me.com"
        scene.passInput.text = "12345"
        scene.goButton.sendActions(for: .touchUpInside)
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: didTapGo function should present
    // an alert controller with title "Error" and message as
    // string equivalent of an error.
    func testDidTapGoB() {
        let exp = expectation(description: "testDidTapGoB")
        let service = AuthRemoteServiceMock()
        let worker = SignInSceneWorkerMock(service: service)
        let theme = SignInScene.Theme()
        let flow = SignInScene.Flow()
        let scene = SignInScene(theme: theme, worker: worker, flow: flow)
        let window = UIWindow(frame: UIScreen.main.bounds)
        let _ = scene.view
        
        flow.scene = scene
        window.rootViewController = scene
        window.makeKeyAndVisible()
        worker.isOK = false
        worker.exp = exp
        worker.output = scene
        worker.callback.workerDidSignInOK = { XCTFail() }
        worker.callback.workerDidSignInWithError = { error in
            XCTAssertNotNil(scene.presentedViewController)
            XCTAssertTrue(scene.presentedViewController is UIAlertController)
            
            let alert = scene.presentedViewController as! UIAlertController
            XCTAssertEqual(alert.title, "Error")
            XCTAssertEqual(alert.message, "\(error)")
        }
        
        scene.goButton.sendActions(for: .touchUpInside)
        wait(for: [exp], timeout: 2.0)
    }
    
    private func constructorTest(withType type: String = "init") {
        let scene: SignInScene
        
        switch type {
        case "coder":
            let decoder = NSCoder()
            let s = SignInScene(coder: decoder)
            XCTAssertNotNil(s)
            scene = s!
        
        default:
            scene = SignInScene()
        }
        
        XCTAssertTrue(scene.theme is SignInScene.Theme)
        XCTAssertTrue(scene.worker is SignInScene.Worker)
        XCTAssertTrue(scene.flow is SignInScene.Flow)
        
        let flow = (scene.flow as! SignInScene.Flow)
        XCTAssertNotNil(flow.scene)
        XCTAssertTrue(flow.scene == scene)
        
        let output = (scene.worker as! SignInScene.Worker).output
        XCTAssertNotNil(output)
        XCTAssertTrue(output is SignInScene)
        
        let outputObject = output as! SignInScene
        XCTAssertTrue(scene == outputObject)
    }
}
