//
//  InitialSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol InitialSceneFlow: class {

    func goToSignIn() -> Bool
    func goToRegister() -> Bool
}

extension InitialScene {
    
    class Flow: InitialSceneFlow {
        
        class Factory {
            
            func signIn(withWaypoint waypoint: ExitWaypoint) -> SignInSceneFactory & SceneFactory {
                let factory = SignInScene.Factory(waypoint: waypoint)
                return factory
            }
            
            func register(withWaypoint waypoint: ExitWaypoint) -> RegisterSceneFactory & SceneFactory {
                let factory = RegisterScene.Factory(waypoint: waypoint)
                return factory
            }
        }
        
        weak var scene: UIViewController?
        var factory: Factory
        var waypoint: PushWaypoint & EntryWaypoint & ExitWaypoint
        
        init() {
            self.factory = Factory()
            self.waypoint = PushWaypointSource()
        }
        
        func goToSignIn() -> Bool {
            guard let parent = scene else {
                return false
            }
            
            let vc = factory.signIn(withWaypoint: waypoint).build()
            return waypoint.withScene(vc).enter(from: parent)
        }
        
        func goToRegister() -> Bool {
            guard let parent = scene else {
                return false
            }
            
            let vc = factory.register(withWaypoint: waypoint).build()
            return waypoint.withScene(vc).enter(from: parent)
        }
    }
}
