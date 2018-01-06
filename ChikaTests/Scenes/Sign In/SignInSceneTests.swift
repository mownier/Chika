//
//  SignInSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika
import TNCore

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
    
    // CONTEXT: didTapBack function should call the exit
    // function in waypoint given that the left bar button
    // item is tapped
    func testDidTapBackA() {
        let theme = SignInScene.Theme()
        let worker = SignInScene.Worker()
        let flow = SignInScene.Flow()
        let waypoint = AppExitWaypointMock()
        let scene = SignInScene(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        let view = scene.view
        let target = scene.navigationItem.leftBarButtonItem!.target!
        let selector = scene.navigationItem.leftBarButtonItem!.action!
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        waypoint.isExitCalled = false
        target.performSelector(onMainThread: selector, with: nil, waitUntilDone: true)
        XCTAssertTrue(waypoint.isExitCalled)
    }
    
    // CONTEXT: workerDidSignInWithError should call the
    // showError function in flow given that the worker
    // produces an error
    func testWorkerDidSignInWithErrorA() {
        let theme = SignInScene.Theme()
        let worker = SignInSceneWorkerMock()
        let flow = SignInSceneFlowMock()
        let waypoint = SignInScene.ExitWaypoint()
        let scene = SignInScene(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
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
