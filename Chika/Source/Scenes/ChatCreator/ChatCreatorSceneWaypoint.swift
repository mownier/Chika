//
//  ChatCreatorSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneEntryWaypoint: class {
    
    func withDelegate(_ what: ChatCreatorSceneDelegate?) -> ChatCreatorSceneEntryWaypoint
    func withMinimumOtherParticipantLimit(_ what: UInt) -> ChatCreatorSceneEntryWaypoint
    func withDefaultParticipants(_ what: [Person]) -> AppEntryWaypoint
}

extension ChatCreatorScene {
    
    class EntryWaypoint: AppEntryWaypoint, ChatCreatorSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ChatCreatorSceneFactory
            var nav: AppNavigationControllerFactory
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
            let nav = factory.nav.build(root: scene)
            parent.present(nav, animated: true, completion: nil)
            return true
        }
        
        func withDefaultParticipants(_ what: [Person]) -> AppEntryWaypoint {
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
