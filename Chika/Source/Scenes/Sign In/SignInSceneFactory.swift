//
//  SignInSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import TNCore

protocol SignInSceneFactory: class {
    
    func withTheme(_ theme: SignInSceneTheme) -> SceneFactory
}

extension SignInScene {
    
    class Factory: SceneFactory, SignInSceneFactory {
        
        var flow: SignInSceneFlow
        var theme: SignInSceneTheme
        var worker: SignInSceneWorker
        var waypoint: ExitWaypoint
        var interaction: SignInSceneInteraction & SignInSceneInteractionBlock
        
        init(waypoint: ExitWaypoint) {
            let flow = Flow()
            let theme = Theme()
            let worker = Worker()
            let interaction = Interaction(waypoint: waypoint, worker: worker)
            
            self.flow = flow
            self.theme = theme
            self.worker = worker
            self.waypoint = waypoint
            self.interaction = interaction
        }
        
        func build() -> UIViewController {
            let scene = SignInScene()
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
        
        func withTheme(_ aTheme: SignInSceneTheme) -> SceneFactory {
            theme = aTheme
            return self
        }
    }
}
