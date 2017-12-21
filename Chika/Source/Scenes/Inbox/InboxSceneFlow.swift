//
//  InboxSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InboxSceneFlow: class {

    func goToConvo(chat: Chat?, delegate: ConvoSceneDelegate?) -> Bool
}

extension InboxScene {
    
    class Flow: InboxSceneFlow {
        
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
        
        func goToConvo(chat: Chat?, delegate: ConvoSceneDelegate?) -> Bool {
            guard let scene = scene, let chat = chat else {
                return false
            }
            
            return waypoint.convoScene.enter(from: scene, chat: chat, delegate: delegate)
        }
    }
}
