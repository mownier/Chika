//
//  UINavigationControllerFactoryTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class UINavigationControllerFactoryTests: XCTestCase {
    
    // CONTEXT: build function should return a UINavigationController
    // whose topViewController must be the root
    func testBuildA() {
        let factory = UINavigationController.Factory()
        let root = UIViewController()
        let nav = factory.build(root: root)
        XCTAssertTrue(nav.topViewController == root)
    }
}
