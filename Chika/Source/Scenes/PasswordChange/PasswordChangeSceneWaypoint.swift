//
//  PasswordChangeSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension PasswordChangeScene {
    
    class EntryWaypoint: AppEntryWaypoint {
        
        struct Factory {
            
            var scene: PasswordChangeSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let scene = PasswordChangeScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.scene.build()
            let nav = factory.nav.build(root: scene)
            parent.present(nav, animated: true, completion: nil)
            return true
        }
    }
    
    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard scene != nil else {
                return false
            }
            
            scene?.dismiss(animated: true, completion: nil)
            return true
        }
    }
}
