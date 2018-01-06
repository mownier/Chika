//
//  ChatCreatorSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol ChatCreatorSceneEntryWaypoint: class {
    
    func withDelegate(_ what: ChatCreatorSceneDelegate?) -> ChatCreatorSceneEntryWaypoint
    func withMinimumOtherParticipantLimit(_ what: UInt) -> ChatCreatorSceneEntryWaypoint
    func withDefaultParticipants(_ what: [Person]) -> TNCore.EntryWaypoint
}

extension ChatCreatorScene {
    
    class EntryWaypoint: TNCore.EntryWaypoint, ChatCreatorSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ChatCreatorSceneFactory
            var nav: NavigationControllerFactory
        }
        
        var factory: Factory
        var participants: [Person]
        var delegate: ChatCreatorSceneDelegate?
        var limit: UInt
        
        init(factory: Factory) {
            self.factory = factory
            self.participants = []
            self.limit = 1
        }
        
        convenience init() {
            let nav = UINavigationController.Factory()
            let scene = ChatCreatorScene.Factory()
            let factory = Factory(scene: scene, nav: nav)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.scene.build(withDefaultParticipants: participants, minimumOtherParticipantLimit: limit, delegate: delegate)
            let nav = factory.nav.withRoot(scene).build()
            parent.present(nav, animated: true, completion: nil)
            return true
        }
        
        func withDefaultParticipants(_ what: [Person]) -> TNCore.EntryWaypoint {
            participants = what
            return self
        }
        
        func withDelegate(_ what: ChatCreatorSceneDelegate?) -> ChatCreatorSceneEntryWaypoint {
            delegate = what
            return self
        }
        
        func withMinimumOtherParticipantLimit(_ what: UInt) -> ChatCreatorSceneEntryWaypoint {
            limit = what
            return self
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
