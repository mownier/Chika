//
//  AboutSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

extension AboutScene {
    
    class EntryWaypoint: TNCore.EntryWaypoint {
        
        struct Factory {
            
            var scene: AboutSceneFactory
            var nav: NavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let scene = AboutScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.scene.build()
            let nav = factory.nav.build(root: scene)
            DispatchQueue.main.async {
                parent.present(nav, animated: true, completion: nil)
            }
            return true
        }
    }
    
    class ExitWaypoint: TNCore.ExitWaypoint {
        
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
