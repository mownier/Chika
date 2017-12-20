//
//  ContactChatSettingSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneFlow: class {

}

extension ContactChatSettingScene {
    
    class Flow: ContactChatSettingSceneFlow {
    
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
