//
//  HomeSceneFlowTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneFlowTests: XCTestCase {
    
    // CONTEXT: Constructor should have properties homeSceneFactory
    // and navControllerFactor of type HomeScene.Factory and
    // UINavigationController.Factory respectively.
    func testInitA() {
        let flow = HomeScene.Flow()
        XCTAssertTrue(flow.homeSceneFactory is HomeScene.Factory)
        XCTAssertTrue(flow.navControllerFactory is UINavigationController.Factory)
    }
    
    // CONTEXT: connect function should fail to put the home scene
    // in window given that the parent.view's window is nil
    func testConnectA() {
        let flow = HomeScene.Flow()
        let parent = UIViewController()
        let ok = flow.connect(from: parent)
        XCTAssertFalse(ok)
    }
    
    // CONTEXT: connect function should put the home scene in window
    // given that window.rootViewController is a UINavigationController.
    // The nav.viewControllers should only be 1 and it should be an
    // instance of HomeScene
    func testConnectB() {
        let flow = HomeScene.Flow()
        let parent = UIViewController()
        let child1 = UIViewController()
        let child2 = UIViewController()
        let nav = UINavigationController(rootViewController: parent)
        let window = UIWindow(frame: UIScreen.main.bounds)
        parent.view = ViewMock(win: window)
        child1.view = ViewMock(win: window)
        child2.view = ViewMock(win: window)
        window.rootViewController = nav
        nav.pushViewController(child1, animated: false)
        nav.pushViewController(child2, animated: false)
        XCTAssertEqual(nav.viewControllers.count, 3)
        let ok = flow.connect(from: child2)
        XCTAssertTrue(ok)
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers[0] is HomeScene)
    }
    
    // CONTEXT: connect function should put the home scene in window
    // given that window.rootViewController is not a UINavigationController.
    // It should create a UINavigationController with rootViewController
    // as an instance of HomeScene class
    func testConnectC() {
        let flow = HomeScene.Flow()
        let parent = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        parent.view = ViewMock(win: window)
        window.rootViewController = parent
        let ok = flow.connect(from: parent)
        XCTAssertTrue(ok)
        XCTAssertTrue(window.rootViewController is UINavigationController)
        let nav = window.rootViewController as! UINavigationController
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers[0] is HomeScene)
    }
}
