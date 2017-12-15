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
    var presenceSwitcher: AppPresenceSwitcher?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        presenceSwitcher = PresenceSwitcher()
        
        let waypoint = RootWaypoint()
        let _ = waypoint.makeRoot(from: window)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        presenceSwitcher?.setActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        presenceSwitcher?.setInactive()
    }
}
