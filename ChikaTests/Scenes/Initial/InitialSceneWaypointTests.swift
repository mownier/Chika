//
//  InitialSceneWaypointTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneWaypointTests: XCTestCase {
    
    // CONTEXT: Constructor should have default factory
    // initialScene and navController as InitialScene.Factory
    // and UINavigationController.Factory respectively
    func testInitA() {
        let waypoint = InitialScene.Waypoint()
        XCTAssertTrue(waypoint.factory.initialScene is InitialScene.Factory)
        XCTAssertTrue(waypoint.factory.navController is UINavigationController.Factory)
    }
}
