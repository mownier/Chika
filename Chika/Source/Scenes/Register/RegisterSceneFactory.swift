//
//  RegisterSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import TNCore

protocol RegisterSceneFactory: class {
    
    func withTheme(_ theme: RegisterSceneTheme) -> SceneFactory
}

extension RegisterScene {
    
    class Factory: SceneFactory, RegisterSceneFactory {
        
        var flow: RegisterSceneFlow
        var theme: RegisterSceneTheme
        var worker: RegisterSceneWorker
        var waypoint: ExitWaypoint
        var interaction: RegisterSceneInteraction & RegisterSceneInteractionBlock
        
        init(waypoint: ExitWaypoint) {
            let flow = Flow()
            let worker = Worker()
            let theme = Theme()
            let interaction = Interaction(waypoint: waypoint, worker: worker)
            
            self.flow = flow
            self.theme = theme
            self.worker = worker
            self.waypoint = waypoint
            self.interaction = interaction
        }
        
        func build() -> UIViewController {
            let scene = RegisterScene()
            scene.flow = flow
            scene.theme = theme
            scene.worker = worker
            scene.interaction = interaction
            
            interaction.onTapGo { () -> (String?, String?) in
                scene.indicator.startAnimating()
                scene.passInput.resignFirstResponder()
                scene.emailInput.resignFirstResponder()
                scene.emailInput.isUserInteractionEnabled = false
                scene.passInput.isUserInteractionEnabled = false
                scene.goButton.isUserInteractionEnabled = false
                let email = scene.emailInput.text
                let pass = scene.passInput.text
                return (email, pass)
            }
            
            return scene
        }
        
        func withTheme(_ aTheme: RegisterSceneTheme) -> SceneFactory {
            theme = aTheme
            return self
        }
    }
}
