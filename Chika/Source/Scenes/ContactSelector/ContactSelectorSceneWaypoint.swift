//
//  ContactSelectorSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol ContactSelectorSceneEntryWaypoint {
    
    func withDelegate(_ aDelegate: ContactSelectorSceneDelegate?) -> ContactSelectorSceneEntryWaypoint
    func withExcludedPersons(_ persons: [Person]) -> TNCore.EntryWaypoint
}

extension ContactSelectorScene {
    
    class EntryWaypoint: TNCore.EntryWaypoint, ContactSelectorSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ContactSelectorSceneFactory
        }
        
        var factory: Factory
        weak var delegate: ContactSelectorSceneDelegate?
        var excludedPersons: [Person]
        
        init(factory: Factory) {
            self.factory = factory
            self.excludedPersons = []
        }
        
        convenience init() {
            let scene = ContactSelectorScene.Factory()
            let factory = Factory(scene: scene)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard let nav = parent.navigationController else {
                return false
            }
            
            let scene = factory.scene.build(withDelegate: delegate, excludedPersons: excludedPersons)
            nav.pushViewController(scene, animated: true)
            delegate = nil
            excludedPersons.removeAll()
            
            return true
        }
        
        func withDelegate(_ aDelegate: ContactSelectorSceneDelegate?) -> ContactSelectorSceneEntryWaypoint {
            delegate = aDelegate
            return self
        }
        
        func withExcludedPersons(_ persons: [Person]) -> TNCore.EntryWaypoint {
            excludedPersons = persons
            return self
        }
    }
    
    class ExitWaypoint: TNCore.ExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let nav = scene?.navigationController, nav.topViewController == scene else {
                return false
            }
            
            nav.popViewController(animated: true)
            return true
        }
    }
}
