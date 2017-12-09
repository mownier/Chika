//
//  ProfileSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileSceneFlow: class {

    func goToContactRequest() -> Bool
}

extension ProfileScene {
    
    class Flow: ProfileSceneFlow {
        
        struct Waypoint {
            
            var contactRequest: AppEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let contactRequest = ContactRequestScene.EntryWaypoint()
            let waypoint = Waypoint(contactRequest: contactRequest)
            self.init(waypoint: waypoint)
        }
        
        func goToContactRequest() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.contactRequest.enter(from: scene)
        }
    }
}
