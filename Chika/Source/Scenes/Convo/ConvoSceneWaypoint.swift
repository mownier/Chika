//
//  ConvoSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneEntryWaypoint {
    
    func enter(from parent: UIViewController, chat: Chat, delegate: ConvoSceneDelegate?)-> Bool
}

extension ConvoScene {

    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let scene = scene, scene.presentingViewController != nil else {
                return false
            }
            
            scene.dismiss(animated: true, completion: nil)
            return true
        }
    }
    
    class EntryWaypoint: ConvoSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ConvoSceneFactory
            var nav: AppNavigationControllerFactory
        }
        
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let scene = ConvoScene.Factory()
            let nav = UINavigationController.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController, chat: Chat, delegate: ConvoSceneDelegate?) -> Bool {
            let scene = factory.scene.build(chat: chat)
            scene.delegate = delegate
            let nav = factory.nav.build(root: scene)
            DispatchQueue.main.async {
                parent.present(nav, animated: true, completion: nil)
            }
            return true
        }
    }
}
