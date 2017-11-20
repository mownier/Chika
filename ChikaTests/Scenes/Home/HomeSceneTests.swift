//
//  HomeSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneTests: XCTestCase {

    // CONTEXT: Constructor should have an instance of
    // HomeScene.Theme and HomeScene.TabSetup
    func testInitA() {
        let scene = HomeScene()
        XCTAssertTrue(scene.setup is HomeScene.TabSetup)
        XCTAssertTrue(scene.theme is HomeScene.Theme)
        
        let decoder = NSCoder()
        let scene2 = HomeScene(coder: decoder)
        XCTAssertNotNil(scene2)
        XCTAssertTrue(scene2!.setup is HomeScene.TabSetup)
        XCTAssertTrue(scene2!.theme is HomeScene.Theme)
    }
}
