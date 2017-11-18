//
//  RegisterSceneExitWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneExitWaypointTests: XCTestCase {
    
    // CONTEXT: exit function should return false given
    // that scene is nil
    func testExitA() {
        let waypoint = RegisterScene.ExitWaypoint()
        waypoint.scene = nil
        let ok = waypoint.exit()
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: exit function should return false given
    // that the scene has no navigation controller
    func testExitB() {
        let waypoint = RegisterScene.ExitWaypoint()
        waypoint.scene = UIViewController()
        let ok = waypoint.exit()
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: exit function should return false given
    // that the navigation controller's topViewController
    // is not the scene
    func testExitC() {
        let otherScene = UIViewController()
        let scene = UIViewController()
        let nav = UINavigationController(rootViewController: scene)
        nav.pushViewController(otherScene, animated: false)
        
        XCTAssertNotNil(otherScene.navigationController)
        XCTAssertEqual(otherScene.navigationController!.viewControllers.count, 2)
        
        let waypoint = RegisterScene.ExitWaypoint()
        waypoint.scene = UIViewController()
        let ok = waypoint.exit()
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: exit function should return false given
    // that the navigation controller's rootViewController
    // is the scene
    func testExitD() {
        let scene = UIViewController()
        let nav = UINavigationController(rootViewController: scene)
        let waypoint = RegisterScene.ExitWaypoint()
        waypoint.scene = scene
        let ok = waypoint.exit()
        XCTAssertTrue(nav.topViewController == scene)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: exit function should return true given
    func testExitE() {
        let otherScene = UIViewController()
        let scene = UIViewController()
        let nav = UINavigationController(rootViewController: otherScene)
        
        nav.pushViewController(scene, animated: false)
        
        XCTAssertNotNil(scene.navigationController)
        XCTAssertEqual(scene.navigationController!.viewControllers.count, 2)
        
        let waypoint = RegisterScene.ExitWaypoint()
        waypoint.scene = scene
        let ok = waypoint.exit()
        XCTAssertTrue(ok)
    }
}
