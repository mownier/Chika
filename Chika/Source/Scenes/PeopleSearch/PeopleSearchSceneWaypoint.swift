//
//  PeopleSearchSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension PeopleSearchScene {
    
    class EntryWaypoint: AppEntryWaypoint {
        
        struct Factory {
            
            var scene: PeopleSearchSceneFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let scene = PeopleSearchScene.Factory()
            let factory = Factory(scene: scene)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            return true
        }
    }
    
    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard scene != nil else {
                return false
            }
            
            return true
        }
    }
    
    class RootWaypoint: AppRootWaypoint {
        
        func makeRoot(from window: UIWindow?) -> Bool {
            guard window != nil else {
                return false
            }
            
            return true
        }
    }
}
