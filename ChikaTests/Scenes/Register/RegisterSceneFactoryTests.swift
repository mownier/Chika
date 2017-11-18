//
//  RegisterSceneFactoryTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneFactoryTests: XCTestCase {
    
    // CONTEXT: build function should return default instance
    // of RegisterScene class
    func testBuildA() {
        let factory = RegisterScene.Factory()
        let scene = factory.build()
        XCTAssertTrue(scene.theme is RegisterScene.Theme)
        XCTAssertTrue(scene.worker is RegisterScene.Worker)
        XCTAssertTrue(scene.flow is RegisterScene.Flow)
        
        let flow = (scene.flow as! RegisterScene.Flow)
        XCTAssertNotNil(flow.scene)
        XCTAssertTrue(flow.scene == scene)
        
        let output = (scene.worker as! RegisterScene.Worker).output
        XCTAssertNotNil(output)
        XCTAssertTrue(output is RegisterScene)
        
        let outputObject = output as! RegisterScene
        XCTAssertTrue(scene == outputObject)
    }
}
