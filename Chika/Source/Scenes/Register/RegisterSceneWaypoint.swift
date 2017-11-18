//
//  RegisterSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension RegisterScene {
    
    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let scene = scene, let nav = scene.navigationController, nav.topViewController == scene, nav.viewControllers.count > 1 else {
                return false
            }
            
            nav.popViewController(animated: true)
            return true
        }
    }
    
    class EntryWaypoint: AppEntryWaypoint {
        
        var sceneFactory: RegisterSceneFactory
        
        init(sceneFactory: RegisterSceneFactory = RegisterScene.Factory()) {
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
