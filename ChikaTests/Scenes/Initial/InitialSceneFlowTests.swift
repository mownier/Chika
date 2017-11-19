//
//  InitialSceneFlowTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneFlowTests: XCTestCase {
    
    // CONTEXT: Constructor should have waypoint.signIn as
    // instance of InitialScene.EntryWaypoint and a nil scene
    func testInitA() {
        let flow = InitialScene.Flow()
        XCTAssertTrue(flow.waypoint.signIn is SignInScene.EntryWaypoint)
        XCTAssertNil(flow.scene)
    }
    
    // CONTEXT: goToSignIn function should return false
    // given that scene is nil
    func testGoToSignInA() {
        let flow = InitialScene.Flow()
        flow.scene = nil
        let ok = flow.goToSignIn()
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: goToSignIn function should call the enter
    // function in waypoint.signIn given that there is a scene
    func testGoToSignInB() {
        let signIn = AppEntryWaypointMock()
        let register = AppEntryWaypointMock()
        let waypoint = InitialScene.Flow.Waypoint(signIn: signIn, register: register)
        let flow = InitialScene.Flow(waypoint: waypoint)
        let scene = UIViewController()
        flow.scene = scene
        signIn.isEnterCalled = false
        let _ = flow.goToSignIn()
        XCTAssertTrue(signIn.isEnterCalled)
    }
    
    // CONTEXT: register function should return false
    // given that scene is nil
    func testRegisterA() {
        let flow = InitialScene.Flow()
        flow.scene = nil
        let ok = flow.goToRegister()
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: goToRegister function should call the enter
    // function in waypoint.register given that there is a scene
    func testGoToRegisterB() {
        let signIn = AppEntryWaypointMock()
        let register = AppEntryWaypointMock()
        let waypoint = InitialScene.Flow.Waypoint(signIn: signIn, register: register)
        let flow = InitialScene.Flow(waypoint: waypoint)
        let scene = UIViewController()
        flow.scene = scene
        register.isEnterCalled = false
        let _ = flow.goToRegister()
        XCTAssertTrue(register.isEnterCalled)
    }
}
