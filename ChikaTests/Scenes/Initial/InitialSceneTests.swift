//
//  InitialSceneTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InitialSceneTests: XCTestCase {
    
    // CONTEXT: Constructor should have the default value of
    // theme and flow properties as intance of InitialScene.Theme
    // and InitialScene.Flow respectively
    func testInitA() {
        var scene = InitialScene()
        XCTAssertTrue(scene.theme is InitialScene.Theme)
        XCTAssertTrue(scene.flow is InitialScene.Flow)
        
        scene = InitialScene(coder: NSCoder())!
        XCTAssertTrue(scene.theme is InitialScene.Theme)
        XCTAssertTrue(scene.flow is InitialScene.Flow)
    }
}
