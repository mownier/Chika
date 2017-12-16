//
//  ChatSettingSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneFlow: class {

}

extension ChatSettingScene {
    
    class Flow: ChatSettingSceneFlow {
    
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
