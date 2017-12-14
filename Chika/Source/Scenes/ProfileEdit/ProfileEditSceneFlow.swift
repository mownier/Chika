//
//  ProfileEditSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileEditSceneFlow: class {

}

extension ProfileEditScene {
    
    class Flow: ProfileEditSceneFlow {
    
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
