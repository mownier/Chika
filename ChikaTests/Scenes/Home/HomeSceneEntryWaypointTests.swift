//
//  HomeSceneEntryWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneEntryWaypointTests: XCTestCase {
    
    // CONTEXT: Constructor should have default instance
    // of factory.homeScene and factory.navController as
    // HomeScene.Factory and UINavigationController.Factory
    // respectively
    func testInitA() {
        let waypoint = HomeScene.EntryWaypoint()
        XCTAssertTrue(waypoint.factory.homeScene is HomeScene.Factory)
        XCTAssertTrue(waypoint.factory.navController is UINavigationController.Factory)
    }
    
    // CONTEXT: enter function should return false given
    // that the window is nil
    func testEnterA() {
        let waypoint = HomeScene.EntryWaypoint()
        let parent = UIViewController()
        let ok = waypoint.enter(from: parent)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: enter function should return true given
    // that window.rootViewController is not UINavigationController
    // and after peforming the function, an instance of
    // UINavigationController, having a topViewController as
    // HomeScene, will be the root of the window
    func testEnterB() {
        let parent = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = parent
        window.makeKeyAndVisible()
        let waypoint = HomeScene.EntryWaypoint()
        let ok = waypoint.enter(from: parent)
        XCTAssertTrue(ok)
        XCTAssertTrue(window.rootViewController is UINavigationController)
        let nav = window.rootViewController as! UINavigationController
        XCTAssertTrue(nav.topViewController is HomeScene)
    }
    
    // CONTEXT: enter function should return true given
    // that window.rootViewController is UINavigationController
    // having a topViewController as HomeScene
    func testEnterC() {
        let parent = UIViewController()
        let nav = UINavigationController(rootViewController: parent)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        let waypoint = HomeScene.EntryWaypoint()
        let ok = waypoint.enter(from: nav)
        XCTAssertTrue(ok)
        XCTAssertTrue(nav.topViewController is HomeScene)
    }
}
