//
//  HomeSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol HomeSceneFlow: class {
    
    func connect(from scene: UIViewController) -> Bool
}

extension HomeScene {
    
    class Flow: HomeSceneFlow {
        
        var homeSceneFactory: HomeSceneFactory
        var navControllerFactory: AppNavigationControllerFactory
        
        init(homeSceneFactory: HomeSceneFactory = HomeScene.Factory(),
            navControllerFactory: AppNavigationControllerFactory = UINavigationController.Factory()) {
            self.homeSceneFactory = homeSceneFactory
            self.navControllerFactory = navControllerFactory
        }
        
        func connect(from parent: UIViewController) -> Bool {
            guard let window = parent.view.window else {
                return false
            }
            
            let scene = homeSceneFactory.build()
            
            guard let nav = window.rootViewController as? UINavigationController else {
                let nav = navControllerFactory.build(root: scene)
                window.rootViewController = nav
                return true
            }
            
            nav.popToRootViewController(animated: true)
            nav.viewControllers[0] = scene
            return true
        }
    }
}
