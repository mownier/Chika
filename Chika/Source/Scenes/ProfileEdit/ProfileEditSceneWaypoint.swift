//
//  ProfileEditSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileEditSceneEntryWaypoint: class {
    
    func withDelegate(_ : ProfileEditSceneDelegate?) -> ProfileEditSceneEntryWaypoint
    func withPerson(_ : Person) -> AppEntryWaypoint
}

extension ProfileEditScene {
    
    class EntryWaypoint: AppEntryWaypoint, ProfileEditSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ProfileEditSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        var factory: Factory
        var me: Person
        weak var delegate: ProfileEditSceneDelegate?
        
        init(factory: Factory) {
            self.factory = factory
            self.me = Person()
        }
        
        convenience init() {
            let scene = ProfileEditScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard !me.id.isEmpty else {
                return false
            }
            
            let scene = factory.scene.buildWith(person: me, delegate: delegate)
            let nav = factory.nav.build(root: scene)
            parent.present(nav, animated: true, completion: nil)
            delegate = nil
            return true
        }
        
        func withPerson(_ person: Person) -> AppEntryWaypoint {
            me = person
            return self
        }
        
        func withDelegate(_ aDelegate: ProfileEditSceneDelegate?) -> ProfileEditSceneEntryWaypoint {
            delegate = aDelegate
            return self
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
