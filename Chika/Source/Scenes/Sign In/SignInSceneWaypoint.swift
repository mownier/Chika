//
//  SignInSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

extension SignInScene {
    
    class ExitWaypoint: TNCore.ExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let scene = scene, let nav = scene.navigationController, nav.topViewController == scene, nav.viewControllers.count > 1 else {
                return false
            }
            
            nav.popViewController(animated: true)
            return true
        }
    }
    
    class EntryWaypoint: TNCore.EntryWaypoint {
        
        var sceneFactory: SignInSceneFactory
        
        init(sceneFactory: SignInSceneFactory = SignInScene.Factory()) {
            self.sceneFactory = sceneFactory
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard let nav = parent.navigationController else {
                return false
            }
            
            let scene = sceneFactory.build()
            nav.pushViewController(scene, animated: true)
            return true
        }
    }
}
