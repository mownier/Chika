//
//  RegisterSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika
import TNCore

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
    
    // CONTEXT: didTapBack function should call the exit
    // function in waypoint given that the left bar button
    // item is tapped
    func testDidTapBackA() {
        let theme = RegisterScene.Theme()
        let worker = RegisterScene.Worker()
        let flow = RegisterScene.Flow()
        let waypoint = AppExitWaypointMock()
        let scene = RegisterScene(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        let view = scene.view
        let target = scene.navigationItem.leftBarButtonItem!.target!
        let selector = scene.navigationItem.leftBarButtonItem!.action!
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        waypoint.isExitCalled = false
        target.performSelector(onMainThread: selector, with: nil, waitUntilDone: true)
        XCTAssertTrue(waypoint.isExitCalled)
    }
    
    // CONTEXT: workerDidRegisterWithError should call the
    // showError function in flow given that the worker
    // produces an error
    func testWorkerDidRegisterWithErrorA() {
        let theme = RegisterScene.Theme()
        let worker = RegisterSceneWorkerMock()
        let flow = RegisterSceneFlowMock()
        let waypoint = RegisterScene.ExitWaypoint()
        let scene = RegisterScene(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        let view = scene.view
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        worker.output = scene
        worker.isOK = false
        flow.isShowErrorCalled = false
        scene.goButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(flow.isShowErrorCalled)
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
