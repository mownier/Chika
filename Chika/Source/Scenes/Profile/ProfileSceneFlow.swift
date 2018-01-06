//
//  ProfileSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol ProfileSceneFlow: class {

    func goToContactRequest() -> Bool
    func goToProfileEdit(withPerson me: Person, delegate: ProfileEditSceneDelegate?) -> Bool
    func goToEmailUpdate(withDelegate: EmailUpdateSceneDelegate?) -> Bool
    func goToPasswordChange() -> Bool
    func goToInitial() -> Bool
    func goToAbout() -> Bool
    func goToSupport() -> Bool
    func goToSignOut(withDelegate delegate: SignOutSceneDelegate?) -> Bool
}

extension ProfileScene {
    
    class Flow: ProfileSceneFlow, SceneInjectable {
        
        class Factory {
            
            func about(withWaypoint waypoint: ExitWaypoint) -> AboutSceneFactory & SceneFactory {
                let factory = AboutScene.Factory()
                return factory
            }
            
            func support(withWaypoint waypoint: ExitWaypoint) -> SupportSceneFactory & SceneFactory {
                let factory = SupportScene.Factory()
                return factory
            }
            
            func signOut(withWaypoint waypoint: PresentWaypoint & ExitWaypoint) -> SignOutSceneFactory & SceneFactory {
                let factory = SignOutScene.Factory()
                return factory
            }
            
            var initial: InitialSceneFactory & SceneFactory {
                let factory = InitialScene.Factory()
                return factory
            }
        }
        
//        struct Waypoint {
//
//            var contactRequest: TNCore.EntryWaypoint
//            var profileEdit: ProfileEditSceneEntryWaypoint
//            var emailUpdate: EmailUpdateSceneEntryWaypoint
//            var passwordChange: TNCore.EntryWaypoint
//        }
        
        weak var scene: UIViewController?
        var factory: Factory
        var application: UIApplication
        
        init(application: UIApplication = .shared) {
            self.factory = Factory()
            self.application = application
        }
        
        func goToContactRequest() -> Bool {
            return true
        }
        
        func goToProfileEdit(withPerson me: Person, delegate: ProfileEditSceneDelegate?) -> Bool {
            return true
        }
        
        func goToEmailUpdate(withDelegate delegate: EmailUpdateSceneDelegate?) -> Bool {
            return true
        }
        
        func goToPasswordChange() -> Bool {            
            return true
        }
        
        func goToInitial() -> Bool {
            let waypoint = WindowWaypointSource()
            let initialScene = factory.initial.build()
            return waypoint.withWindow(scene?.view.window).withScene(initialScene).makeRoot()
        }
        
        func goToAbout() -> Bool {
            guard let parent = scene else {
                return false
            }
            
            let waypoint = PushWaypointSource()
            let aboutScene = factory.about(withWaypoint: waypoint).build()
            return waypoint.withScene(aboutScene).enter(from: parent)
        }
        
        func goToSupport() -> Bool {
            guard let parent = scene else {
                return false
            }
            
            let waypoint = PushWaypointSource()
            let aboutScene = factory.support(withWaypoint: waypoint).build()
            return waypoint.withScene(aboutScene).enter(from: parent)
        }
        
        func goToSignOut(withDelegate delegate: SignOutSceneDelegate?) -> Bool {
            guard let parent = scene else {
                return false
            }
            
            let waypoint = PresentWaypointSource()
            let aboutScene = factory.signOut(withWaypoint: waypoint).build()
            return waypoint.withScene(aboutScene).enter(from: parent)
        }
        
        func injectScene(_ aScene: UIViewController) {
            scene = aScene
        }
    }
}
