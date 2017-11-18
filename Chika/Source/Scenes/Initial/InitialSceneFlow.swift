//
//  InitialSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InitialSceneFlow: class {

    func goToSignIn() -> Bool
    func goToRegister() -> Bool
}

extension InitialScene {
    
    class Flow: InitialSceneFlow {
        
        struct Waypoint {
            
            var signIn: AppEntryWaypoint
        }
        
        var waypoint: Waypoint
        weak var scene: UIViewController?
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let signIn = SignInScene.EntryWaypoint()
            let waypoint = Waypoint(signIn: signIn)
            self.init(waypoint: waypoint)
        }
        
        func goToSignIn() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            return waypoint.signIn.enter(from: scene)
        }
        
        func goToRegister() -> Bool {
            return false
        }
    }
}
