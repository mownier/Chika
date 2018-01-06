//
//  SupportSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol SupportSceneFactory: class {

    func withTheme(_ theme: SupportSceneTheme) -> SceneFactory & SupportSceneFactory
}

extension SupportScene {
    
    class Factory: SupportSceneFactory, SceneFactory {
    
        func build() -> UIViewController {
            let scene = SupportScene()
            return scene
        }
        
        func withTheme(_ theme: SupportSceneTheme) -> SceneFactory & SupportSceneFactory {
            return self
        }
    }
}
