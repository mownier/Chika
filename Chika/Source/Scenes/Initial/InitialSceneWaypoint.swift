//
//  InitialSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

extension InitialScene {
    
    class RootWaypoint: WindowWaypoint, TNCore.RootWaypoint {        
        
        struct Factory {
            
            var initial: InitialSceneFactory
            var nav: NavigationControllerFactory
        }
        
        var factory: Factory
        var window: UIWindow?
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let initial = InitialScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(initial: initial, nav: nav)
            self.init(factory: factory)
        }
        
        func withWindow(_ aWindow: UIWindow?) -> WindowWaypoint {
            window = aWindow
            return self
        }
        
        func withScene(_ scene: UIViewController) -> RootWaypoint {
            return self
        }
        
        func makeRoot() -> Bool {
            let scene = factory.initial.build()
            let nav = factory.nav.withRoot(scene).build()
            window?.rootViewController = nav
            window = nil
            return true
        }
    }
}
