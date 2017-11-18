//
//  HomeSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension HomeScene {
    
    class EntryWaypoint: AppEntryWaypoint {
        
        struct Factory {
            
            var homeScene: HomeSceneFactory
            var navController: AppNavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let homeScene = HomeScene.Factory()
            let navController = UINavigationController.Factory()
            let factory = Factory(homeScene: homeScene, navController: navController)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard let window = parent.view.window else {
                return false
            }
            
            let scene = factory.homeScene.build()
            
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
}
