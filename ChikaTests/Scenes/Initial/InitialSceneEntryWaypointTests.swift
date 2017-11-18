//
//  InitialSceneEntryWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneEntryWaypointTests: XCTestCase {
    
    // CONTEXT: enter function should return false given
    // that the parent has no window
    func testEnterA() {
        let parent = UIViewController()
        let waypoint = InitialScene.EntryWaypoint()
        let ok = waypoint.enter(from: parent)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: enter function should return true given
    // that window.rootViewController is not UINavigationController
    // and after peforming the function, an instance of
    // UINavigationController, having a topViewController as
    // InitialScene, will be the root of the window
    func testEnterB() {
        let parent = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = parent
        window.makeKeyAndVisible()
        let waypoint = InitialScene.EntryWaypoint()
        let ok = waypoint.enter(from: parent)
        XCTAssertTrue(ok)
        XCTAssertTrue(window.rootViewController is UINavigationController)
        let nav = window.rootViewController as! UINavigationController
        XCTAssertTrue(nav.topViewController is InitialScene)
    }
    
    // CONTEXT: enter function should return true given
    // that window.rootViewController is UINavigationController
    // having a topViewController as InitialScene
    func testEnterC() {
        let parent = UIViewController()
        let nav = UINavigationController(rootViewController: parent)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        let waypoint = InitialScene.EntryWaypoint()
        let ok = waypoint.enter(from: nav)
        XCTAssertTrue(ok)
        XCTAssertTrue(nav.topViewController is InitialScene)
    }
}
