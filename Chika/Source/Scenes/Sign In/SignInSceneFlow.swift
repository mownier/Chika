//
//  SignInSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignInSceneFlow: class {
    
    func goToHome() -> Bool
    func showError(_ error: Error)
}

extension SignInScene {
    
    class Flow: SignInSceneFlow {
        
        struct Waypoint {
            
            var homeScene: AppEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let homeScene = HomeScene.EntryWaypoint()
            let waypoint = Waypoint(homeScene: homeScene)
            self.init(waypoint: waypoint)
        }
        
        func goToHome() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            if scene.isBeingPresented {
                scene.dismiss(animated: true, completion: nil)
            }
            
            return waypoint.homeScene.enter(from: scene)
        }
        
        func showError(_ error: Error) {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            scene?.present(alert, animated: true, completion: nil)
        }
    }
}
