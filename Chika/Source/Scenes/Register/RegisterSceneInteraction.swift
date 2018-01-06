//
//  RegisterSceneInteraction.swift
//  Chika
//
//  Created by Mounir Ybanez on 1/6/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol RegisterSceneInteraction: class {
    
    func didTapBack()
    func didTapGo()
}

protocol RegisterSceneInteractionBlock: class {
    
    func onTapGo(_ block: @escaping (() -> (String?, String?)))
}

extension RegisterScene {
    
    class Interaction: RegisterSceneInteraction, RegisterSceneInteractionBlock {
        
        var waypoint: ExitWaypoint
        var worker: RegisterSceneWorker
        var onTapGoBlock: (() -> (String?, String?))?
        
        init(waypoint: ExitWaypoint, worker: RegisterSceneWorker) {
            self.waypoint = waypoint
            self.worker = worker
        }
        
        func didTapGo() {
            guard let (email, pass) = onTapGoBlock?() else {
                return
            }
            
            worker.register(email: email, pass: pass)
        }
        
        func didTapBack() {
            let _ = waypoint.exit()
        }
        
        func onTapGo(_ block: @escaping (() -> (String?, String?))) {
            onTapGoBlock = block
        }
    }
}
