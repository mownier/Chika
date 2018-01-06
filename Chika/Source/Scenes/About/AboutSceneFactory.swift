//
//  AboutSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol AboutSceneFactory: class {

    func withTheme(_ theme: AboutSceneTheme) -> AboutSceneFactory & SceneFactory
}

extension AboutScene {
    
    class Factory: AboutSceneFactory, SceneFactory {
        
        func build() -> UIViewController {
            let scene = AboutScene()
            return scene
        }
        
        func withTheme(_ theme: AboutSceneTheme) -> AboutSceneFactory & SceneFactory {
            return self
        }
    }
}
