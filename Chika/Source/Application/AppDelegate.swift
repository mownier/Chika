//
//  AppDelegate.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let waypoint = InitialScene.RootWaypoint()
        let _ = waypoint.makeRoot(from: window)
        let _ = handleUITesting()

        return true
    }
    
    func handleUITesting(info: ProcessInfo = ProcessInfo.processInfo) -> Bool {
        if info.arguments.contains("ForceInitialScene") {
            let waypoint = InitialScene.RootWaypoint()
            let _ = waypoint.makeRoot(from: window)
            return true
        }
        
        return false
    }
}

