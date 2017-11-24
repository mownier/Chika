//
//  AppWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol AppEntryWaypoint: class {
    
    func enter(from parent: UIViewController) -> Bool
}

protocol AppExitWaypoint: class {
    
    func exit() -> Bool
}

protocol AppRootWaypoint: class {
    
    func makeRoot(from window: UIWindow?) -> Bool
}

extension AppDelegate {
    
    class RootWaypoint: AppRootWaypoint {
        
        var userID: String?
        var initial: AppRootWaypoint
        var home: AppRootWaypoint
        var isForceInitialScene: Bool
        
        init(userID: String? = Auth.auth().currentUser?.uid, initial: AppRootWaypoint = InitialScene.RootWaypoint(), home: AppRootWaypoint = HomeScene.RootWaypoint(), processInfo: ProcessInfo = ProcessInfo.processInfo) {
            self.userID = userID
            self.initial = initial
            self.home = home
            self.isForceInitialScene = processInfo.arguments.contains("ForceInitialScene")
        }
        
        func makeRoot(from window: UIWindow?) -> Bool {
            guard let window = window else {
                return false
            }
            
            guard let userID = userID, !userID.isEmpty, !isForceInitialScene else {
                return initial.makeRoot(from: window)
            }
            
            return home.makeRoot(from: window)
        }
    }
}
