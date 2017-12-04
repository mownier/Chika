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
    var presenceWriter: PresenceRemoteWriter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        presenceWriter = PresenceRemoteWriterProvider()
        
        let waypoint = RootWaypoint()
        let _ = waypoint.makeRoot(from: window)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard presenceWriter != nil else { return }
        presenceWriter.makeOnline { _ in }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard presenceWriter != nil else { return }
        presenceWriter.makeOffline { _ in }
    }
}
