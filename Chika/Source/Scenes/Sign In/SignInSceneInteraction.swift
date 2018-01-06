//
//  SignInSceneInteraction.swift
//  Chika
//
//  Created by Mounir Ybanez on 1/5/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol SignInSceneInteraction: class {
    
    func didTapGo()
    func didTapBack()
}

protocol SignInSceneInteractionBlock: class {
    
    func onTapGo(_ block: @escaping (() -> (String?, String?)))
}

extension SignInScene {
    
    class Interaction: SignInSceneInteraction, SignInSceneInteractionBlock {
        
        var waypoint: ExitWaypoint
        var worker: SignInSceneWorker
        var onTapGoBlock: (() -> (String?, String?))?
        
        init(waypoint: ExitWaypoint, worker: SignInSceneWorker) {
            self.waypoint = waypoint
            self.worker = worker
        }
        
        func didTapGo() {
            guard let (email, pass) = onTapGoBlock?() else {
                return
            }
            
            worker.signIn(email: email, pass: pass)
        }
        
        func didTapBack() {
            let _ = waypoint.exit()
        }
        
        func onTapGo(_ block: @escaping (() -> (String?, String?))) {
            onTapGoBlock = block
        }
    }
}
