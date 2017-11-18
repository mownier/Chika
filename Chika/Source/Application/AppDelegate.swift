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
        
        let scene = InitialScene()
        let root = UINavigationController(rootViewController: scene)
        root.isNavigationBarHidden = true
        window?.rootViewController = root
        
        handleUITesting()

        return true
    }
    
    private func handleUITesting() {
        if ProcessInfo.processInfo.arguments.contains("ForceInitialScene") {
            let scene = InitialScene()
            let root = UINavigationController(rootViewController: scene)
            root.isNavigationBarHidden = true
            window?.rootViewController = root
        }
    }
}

