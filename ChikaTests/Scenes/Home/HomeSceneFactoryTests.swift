//
//  HomeSceneFactoryTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneFactoryTests: XCTestCase {
    
    // CONTEXT: build function should return default instance
    // of HomeScene class
    func testBuildA() {
        let factory = HomeScene.Factory()
        let _ = factory.build()
    }
}
