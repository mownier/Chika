//
//  AppWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth
import TNCore

extension AppDelegate {
    
    class Flow {
        
        struct Factory {
            
            var nav: NavigationControllerFactory
            var initialScene: InitialSceneFactory
        }
        
        struct Theme {
            
            var nav: NavigationControllerTheme
            var initialScene: InitialSceneTheme
        }
        
        weak var window: UIWindow?
        var factory: Factory
        var waypoint: WindowWaypoint
        var theme: Theme
        
        init(window: UIWindow?) {
            let waypoint = WindowWaypointSource()
            let navTheme = UINavigationController.Theme()
            let navFactory = UINavigationController.Factory()
            let initialSceneTheme = InitialScene.Theme()
            let initialSceneFactory = InitialScene.Factory()
            
            let theme = Theme(nav: navTheme, initialScene: initialSceneTheme)
            let factory = Factory(nav: navFactory, initialScene: initialSceneFactory)
            
            self.theme = theme
            self.window = window
            self.factory = factory
            self.waypoint = waypoint
        }

//        func makeRoot(from window: UIWindow?) -> Bool {
//            guard let window = window else {
//                return false
//            }
//
//            guard let userID = userID, !userID.isEmpty, !isForceInitialScene else {
//                // TODO:
//                return initial.withWindow(window)makeRoot(from: window)
//            }
//
//            return home.makeRoot(from: window)
//        }
    }
}
