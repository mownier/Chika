//
//  HomeSceneRootWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneRootWaypointTests: XCTestCase {
    
    // CONTEXT: Constructor should have default instance
    // of home factory as HomeScene.Factory
    func testInitA() {
        let waypoint = HomeScene.RootWaypoint()
        XCTAssertTrue(waypoint.home is HomeScene.Factory)
    }
    
    // CONTEXT: makeRoot function should return false given
    // that the window is nil
    func testMakeRootA() {
        let waypoint = HomeScene.RootWaypoint()
        let window: UIWindow? = nil
        let ok = waypoint.makeRoot(from: window)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: makeRoot function should return true given
    // that the window is not nil
    func testMakeRootB() {
        let waypoint = HomeScene.RootWaypoint()
        let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        let ok = waypoint.makeRoot(from: window)
        XCTAssertTrue(ok)
    }
}
