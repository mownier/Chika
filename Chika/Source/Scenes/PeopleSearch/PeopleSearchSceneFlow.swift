//
//  PeopleSearchSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol PeopleSearchSceneFlow: class {

    func goToConvo(withChat chat: Chat) -> Bool
    func goToContactRequest() -> Bool
}

extension PeopleSearchScene {
    
    class Flow: PeopleSearchSceneFlow {
    
        struct Waypoint {
    
            var convo: ConvoSceneEntryWaypoint
            var contactRequest: TNCore.EntryWaypoint
        }
    
        weak var scene: UIViewController?
        var waypoint: Waypoint
    
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
    
        convenience init() {
            let convo = ConvoScene.EntryWaypoint()
            let contactRequest = PresentWaypointSource()
            let waypoint = Waypoint(convo: convo, contactRequest: contactRequest)
            self.init(waypoint: waypoint)
        }
        
        func goToConvo(withChat chat: Chat) -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.convo.enter(from: scene, chat: chat, delegate: nil)
        }
        
        func goToContactRequest() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.contactRequest.enter(from: scene)
        }
    }
}
