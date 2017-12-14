//
//  EmailUpdateSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneEntryWaypoint: class {
    
    func withDelegate(_ delegate: EmailUpdateSceneDelegate?) -> EmailUpdateSceneEntryWaypoint
    func withEmail(_ email: String) -> AppEntryWaypoint
}

extension EmailUpdateScene {
    
    class EntryWaypoint: AppEntryWaypoint, EmailUpdateSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: EmailUpdateSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        weak var delegate: EmailUpdateSceneDelegate?
        var factory: Factory
        var email: String
        
        init(factory: Factory) {
            self.factory = factory
            self.email = ""
        }
        
        convenience init() {
            let scene = EmailUpdateScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.scene.build(withEmail: email, delegate: delegate)
            let nav = factory.nav.build(root: scene)
            DispatchQueue.main.async { [weak self] in
                parent.present(nav, animated: true, completion: nil)
                
                guard let this = self else { return }
                this.email = ""
                this.delegate = nil
            }
            return true
        }
        
        func withEmail(_ anEmail: String) -> AppEntryWaypoint {
            email = anEmail
            return self
        }
        
        func withDelegate(_ aDelegate: EmailUpdateSceneDelegate?) -> EmailUpdateSceneEntryWaypoint {
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
