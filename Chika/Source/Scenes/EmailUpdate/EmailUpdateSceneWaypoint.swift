//
//  EmailUpdateSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneEntryWaypoint: class {
    
    func withDelegate(_ delegate: EmailUpdateSceneDelegate?) -> AppEntryWaypoint
}

extension EmailUpdateScene {
    
    class EntryWaypoint: AppEntryWaypoint, EmailUpdateSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: EmailUpdateSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        weak var delegate: EmailUpdateSceneDelegate?
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let scene = EmailUpdateScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.scene.build(withDelegate: delegate)
            let nav = factory.nav.build(root: scene)
            DispatchQueue.main.async { [weak self] in
                parent.present(nav, animated: true, completion: nil)
                
                guard let this = self else { return }
                this.delegate = nil
            }
            return true
        }
        
        func withDelegate(_ aDelegate: EmailUpdateSceneDelegate?) -> AppEntryWaypoint {
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
