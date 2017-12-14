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
    func goToEmailUpdate(withDelegate: EmailUpdateSceneDelegate?) -> Bool
    func goToPasswordChange() -> Bool
    func goToInitial() -> Bool
    func goToAbout() -> Bool
}

extension ProfileScene {
    
    class Flow: ProfileSceneFlow {
        
        struct Waypoint {
            
            var contactRequest: AppEntryWaypoint
            var profileEdit: ProfileEditSceneEntryWaypoint
            var emailUpdate: EmailUpdateSceneEntryWaypoint
            var passwordChange: AppEntryWaypoint
            var initial: AppRootWaypoint
            var about: AppEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        var application: UIApplication
        
        init(waypoint: Waypoint, application: UIApplication) {
            self.waypoint = waypoint
            self.application = application
        }
        
        convenience init() {
            let contactRequest = ContactRequestScene.EntryWaypoint()
            let profileEdit = ProfileEditScene.EntryWaypoint()
            let emailUpdate = EmailUpdateScene.EntryWaypoint()
            let passwordChange = PasswordChangeScene.EntryWaypoint()
            let initial = InitialScene.RootWaypoint()
            let about = AboutScene.EntryWaypoint()
            let waypoint = Waypoint(contactRequest: contactRequest, profileEdit: profileEdit, emailUpdate: emailUpdate, passwordChange: passwordChange, initial: initial, about: about)
            self.init(waypoint: waypoint, application: UIApplication.shared)
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
        
        func goToEmailUpdate(withDelegate delegate: EmailUpdateSceneDelegate?) -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.emailUpdate.withDelegate(delegate).enter(from: scene)
        }
        
        func goToPasswordChange() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.passwordChange.enter(from: scene)
        }
        
        func goToInitial() -> Bool {
            return waypoint.initial.makeRoot(from: application.keyWindow)
        }
        
        func goToAbout() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.about.enter(from: scene)
        }
    }
}
