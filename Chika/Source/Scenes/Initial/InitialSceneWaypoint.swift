//
//  InitialSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension InitialScene {
    
    class RootWaypoint: AppRootWaypoint {
        
        struct Factory {
            
            var initial: InitialSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let initial = InitialScene.Factory()
            let nav = UINavigationController.Factory(navBarTheme: UINavigationBar.Theme.Empty())
            let factory = Factory(initial: initial, nav: nav)
            self.init(factory: factory)
        }
        
        func makeRoot(from window: UIWindow?) -> Bool {
            guard let window = window else {
                return false
            }
            
            let scene = factory.initial.build()
            let nav = factory.nav.build(root: scene)
            window.rootViewController = nav
            return true
        }
    }
}
