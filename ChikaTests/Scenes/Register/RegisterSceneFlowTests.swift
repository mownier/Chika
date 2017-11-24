//
//  RegisterSceneFlowTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneFlowTests: XCTestCase {
    
    // CONTEXT: Constructor should instantiate waypoint.home
    // property with class HomeScene.RootWaypoint
    func testInitA() {
        let flow = RegisterScene.Flow()
        XCTAssertTrue(flow.waypoint.home is HomeScene.RootWaypoint)
    }
    
    // CONTEXT: showError function should show an alert
    // controller coming from the error parameter
    func testShowErrorA() {
        let scene = UIViewController()
        let flow = RegisterScene.Flow()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let error = AppError("Flow error")
        
        window.rootViewController = scene
        window.makeKeyAndVisible()
        flow.scene = scene
        flow.showError(error)
        
        XCTAssertTrue(scene.presentedViewController is UIAlertController)
        let alert = scene.presentedViewController as! UIAlertController
        XCTAssertEqual(alert.title, "Error")
        XCTAssertEqual(alert.message, "\(error)")
    }
    
    // CONTEXT: goToHome function should return false given
    // that scene is nil
    func testGoToHomeA() {
        let flow = RegisterScene.Flow()
        flow.scene = nil
        let ok = flow.goToHome()
        XCTAssertFalse(ok)
    }
}
