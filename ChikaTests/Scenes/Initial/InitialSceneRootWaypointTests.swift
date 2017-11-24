//
//  InitialSceneRootWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneRootWaypointTests: XCTestCase {
    
    // CONTEXT: Constructor should have a factory for
    // initial scene and nav controller as instance of
    // InitialScene.Factory and UINavigationController.Factory
    // and the navController.navBarTheme is an instance
    // of UINavigationBar.Theme.Empty
    func testInitA() {
        let waypoint = InitialScene.RootWaypoint()
        XCTAssertTrue(waypoint.factory.initial is InitialScene.Factory)
        XCTAssertTrue(waypoint.factory.nav is UINavigationController.Factory)
        
        let nav = waypoint.factory.nav as! UINavigationController.Factory
        XCTAssertTrue(nav.navBarTheme is UINavigationBar.Theme.Empty)
    }
    
    // CONTEXT: makeRoot function should return false given
    // that the window is nil
    func testMakeRootA() {
        let waypoint = InitialScene.RootWaypoint()
        let ok = waypoint.makeRoot(from: nil)
        
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: makeRoot function should return true given
    // that there is a window and window's rootViewController
    // should be an instance of UINavigationController and the
    // topViewController is InitialScene
    func testMakeRootB() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let waypoint = InitialScene.RootWaypoint()
        let ok = waypoint.makeRoot(from: window)
        
        XCTAssertTrue(ok)
        XCTAssertTrue(window.rootViewController is UINavigationController)
        
        let nav = window.rootViewController as! UINavigationController
        XCTAssertTrue(nav.topViewController is InitialScene)
    }
}
