//
//  InitialSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension InitialScene {
    
    class Waypoint {
        
        struct Factory {
            
            var initialScene: InitialSceneFactory
            var navController: AppNavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let initialScene = InitialScene.Factory()
            let navController = UINavigationController.Factory()
            let factory = Factory(initialScene: initialScene, navController: navController)
            self.init(factory: factory)
        }
    }

    
    class EntryWaypoint: Waypoint, AppEntryWaypoint {
        
        func enter(from parent: UIViewController) -> Bool {
            guard let window = parent.view.window else {
                return false
            }
            
            let scene = factory.initialScene.build()
            
            guard let nav = window.rootViewController as? UINavigationController else {
                let nav = factory.navController.build(root: scene)
                window.rootViewController = nav
                return true
            }
            
            nav.popToRootViewController(animated: true)
            nav.viewControllers[0] = scene
            return true
        }
    }
    
    class RootWaypoint: Waypoint, AppRootWaypoint {
        
        convenience init() {
            let initialScene = InitialScene.Factory()
            let navController = UINavigationController.Factory(navBarTheme: UINavigationBar.Theme.Empty())
            let factory = Factory(initialScene: initialScene, navController: navController)
            self.init(factory: factory)
        }
        
        func makeRoot(from window: UIWindow?) -> Bool {
            guard let window = window else {
                return false
            }
            
            let scene = factory.initialScene.build()
            let nav = factory.navController.build(root: scene)
            window.rootViewController = nav
            return true
        }
    }
}
