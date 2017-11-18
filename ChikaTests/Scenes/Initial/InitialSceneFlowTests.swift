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
        let ok = flow.goToSignIn()
        XCTAssertFalse(ok)
    }
}
