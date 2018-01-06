//
//  InitialSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol InitialSceneFactory: class {
    
    func withTheme(_ theme: InitialSceneTheme) -> SceneFactory
}

extension InitialScene {
    
    class Factory: InitialSceneFactory, SceneFactory {
        
        var theme: InitialSceneTheme
        var flow: InitialSceneFlow
        var interaction: InitialSceneInteraction
        
        init() {
            let flow = Flow()
            let theme = Theme()
            let interaction = Interaction(flow: flow)
            
            self.flow = flow
            self.theme = theme
            self.interaction = interaction
        }
        
        func withTheme(_ aTheme: InitialSceneTheme) -> SceneFactory {
            theme = aTheme
            return self
        }
        
        func build() -> UIViewController {
            let scene = InitialScene()
            scene.flow = flow
            scene.theme = theme
            scene.interaction = interaction
            return scene
        }
    }
}
