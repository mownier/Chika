//
//  SignInSceneFactoryTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneFactoryTests: XCTestCase {
    
    // CONTEXT: build function should return default instance
    // of SignInScene class
    func testBuildA() {
        let factory = SignInScene.Factory()
        let scene = factory.build()
        XCTAssertTrue(scene.theme is SignInScene.Theme)
        XCTAssertTrue(scene.worker is SignInScene.Worker)
        XCTAssertTrue(scene.flow is SignInScene.Flow)
        
        let flow = (scene.flow as! SignInScene.Flow)
        XCTAssertNotNil(flow.scene)
        XCTAssertTrue(flow.scene == scene)
        
        let output = (scene.worker as! SignInScene.Worker).output
        XCTAssertNotNil(output)
        XCTAssertTrue(output is SignInScene)
        
        let outputObject = output as! SignInScene
        XCTAssertTrue(scene == outputObject)
    }
}
