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
    func goToProfileEdit(withPerson me: Person, delegate: ProfileEditSceneDelegate?) -> Bool
}

extension ProfileScene {
    
    class Flow: ProfileSceneFlow {
        
        struct Waypoint {
            
            var contactRequest: AppEntryWaypoint
            var profileEdit: ProfileEditSceneEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let contactRequest = ContactRequestScene.EntryWaypoint()
            let profileEdit = ProfileEditScene.EntryWaypoint()
            let waypoint = Waypoint(contactRequest: contactRequest, profileEdit: profileEdit)
            self.init(waypoint: waypoint)
        }
        
        func goToContactRequest() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.contactRequest.enter(from: scene)
        }
        
        func goToProfileEdit(withPerson me: Person, delegate: ProfileEditSceneDelegate?) -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.profileEdit.withDelegate(delegate).withPerson(me).enter(from: scene)
        }
    }
}
