//
//  ChatSettingSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneFlow: class {

    func goToContactSelector(withDelegate: ContactSelectorSceneDelegate?) -> Bool
}

extension ChatSettingScene {
    
    class Flow: ChatSettingSceneFlow {
    
        struct Waypoint {
    
            var contactSelector: ContactSelectorSceneEntryWaypoint
        }
    
        weak var scene: UIViewController?
        var waypoint: Waypoint
    
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
    
        convenience init() {
            let contactSelector = ContactSelectorScene.EntryWaypoint()
            let waypoint = Waypoint(contactSelector: contactSelector)
            self.init(waypoint: waypoint)
        }
        
        func goToContactSelector(withDelegate delegate: ContactSelectorSceneDelegate?) -> Bool {
            guard let scene = scene else { return false }
            return waypoint.contactSelector.withDelegate(delegate).enter(from: scene)
        }
    }
}
