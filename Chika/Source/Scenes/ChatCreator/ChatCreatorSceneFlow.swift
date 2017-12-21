//
//  ChatCreatorSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneFlow: class {

}

extension ChatCreatorScene {
    
    class Flow: ChatCreatorSceneFlow {
    
        struct Waypoint {
    
        }
    
        weak var scene: UIViewController?
        var waypoint: Waypoint
    
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
    
        convenience init() {
            let waypoint = Waypoint()
            self.init(waypoint: waypoint)
        }
    }
}
