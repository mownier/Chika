//
//  ContactsSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneFlow: class {

    func goToConvo(withChat chat: Chat) -> Bool
}

extension ContactsScene {
    
    class Flow: ContactsSceneFlow {
        
        struct Waypoint {
            
            var convoScene: ConvoSceneEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let convoScene = ConvoScene.EntryWaypoint()
            let waypoint = Waypoint(convoScene: convoScene)
            self.init(waypoint: waypoint)
        }
        
        func goToConvo(withChat chat: Chat) -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.convoScene.enter(from: scene, chat: chat)
        }
    }
}
