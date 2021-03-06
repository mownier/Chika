//
//  SignInSceneEntryWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneEntryWaypointTests: XCTestCase {
    
    // CONTEXT: Constructor must have SignInScene.Factory as
    // default instance of sceneFactory
    func testInitA() {
        let waypoint = SignInScene.EntryWaypoint()
        XCTAssertTrue(waypoint.sceneFactory is SignInScene.Factory)
    }
    
    // CONTEXT: enter function should return false given
    // that parent has no navigation controller
    func testEnterA() {
        let parent = UIViewController()
        let waypoint = SignInScene.EntryWaypoint()
        let ok = waypoint.enter(from: parent)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: enter function should return true
    func testEnterB() {
        let parent = UIViewController()
        let _ = UINavigationController(rootViewController: parent)
        let waypoint = SignInScene.EntryWaypoint()
        let ok = waypoint.enter(from: parent)
        XCTAssertTrue(ok)
    }
}
