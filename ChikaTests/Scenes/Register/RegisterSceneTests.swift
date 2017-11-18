//
//  RegisterSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneTests: XCTestCase {
    
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
        let worker = RegisterSceneWorkerMock(service: service)
        let theme = RegisterScene.Theme()
        let flow = RegisterSceneFlowMock()
        let waypoint = RegisterScene.ExitWaypoint()
        let scene = RegisterScene(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        let _ = scene.view
        
        worker.exp = exp
        worker.output = scene
        worker.callback.workerDidRegisterWithError = { _ in XCTFail() }
        worker.callback.workerDidRegisterOK = {
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
    
    private func constructorTest(withType type: String = "init") {
        let scene: RegisterScene
        
        switch type {
        case "coder":
            let decoder = NSCoder()
            let s = RegisterScene(coder: decoder)
            XCTAssertNotNil(s)
            scene = s!
            
        default:
            scene = RegisterScene()
        }
        
        XCTAssertTrue(scene.theme is RegisterScene.Theme)
        XCTAssertTrue(scene.worker is RegisterScene.Worker)
        XCTAssertTrue(scene.flow is RegisterScene.Flow)
        
        let flow = (scene.flow as! RegisterScene.Flow)
        XCTAssertNotNil(flow.scene)
        XCTAssertTrue(flow.scene == scene)
        
        let output = (scene.worker as! RegisterScene.Worker).output
        XCTAssertNotNil(output)
        XCTAssertTrue(output is RegisterScene)
        
        let outputObject = output as! RegisterScene
        XCTAssertTrue(scene == outputObject)
    }
}
