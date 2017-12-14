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
    func goToEmailUpdate(withEmail email: String, delegate: EmailUpdateSceneDelegate?) -> Bool
    func goToPasswordChange() -> Bool
}

extension ProfileScene {
    
    class Flow: ProfileSceneFlow {
        
        struct Waypoint {
            
            var contactRequest: AppEntryWaypoint
            var profileEdit: ProfileEditSceneEntryWaypoint
            var emailUpdate: EmailUpdateSceneEntryWaypoint
            var passwordChange: AppEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let contactRequest = ContactRequestScene.EntryWaypoint()
            let profileEdit = ProfileEditScene.EntryWaypoint()
            let emailUpdate = EmailUpdateScene.EntryWaypoint()
            let passwordChange = PasswordChangeScene.EntryWaypoint()
            let waypoint = Waypoint(contactRequest: contactRequest, profileEdit: profileEdit, emailUpdate: emailUpdate, passwordChange: passwordChange)
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
        
        func goToEmailUpdate(withEmail email: String, delegate: EmailUpdateSceneDelegate?) -> Bool {
            guard let scene = scene, !email.isEmpty else {
                return false
            }
            
            return waypoint.emailUpdate.withDelegate(delegate).withEmail(email).enter(from: scene)
        }
        
        func goToPasswordChange() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.passwordChange.enter(from: scene)
        }
    }
}
