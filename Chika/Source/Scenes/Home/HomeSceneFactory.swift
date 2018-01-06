//
//  HomeSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol HomeSceneFactory: class {

    func withTheme(_ theme: HomeSceneTheme) -> HomeSceneFactory & SceneFactory
}

extension HomeScene {
    
    class Factory: HomeSceneFactory, SceneFactory {
        
        var theme: HomeSceneTheme
        var setup: HomeSceneTabSetup
        
        init() {
            let theme = Theme()
            let setup = TabSetup()
            
            self.theme = theme
            self.setup = setup
        }
        
        func withTheme(_ aTheme: HomeSceneTheme) -> HomeSceneFactory & SceneFactory {
            theme = aTheme
            return self
        }
        
        func build() -> UIViewController {
            let scene = HomeScene()
            scene.theme = theme
            scene.setup = setup
            return scene
        }
    }
}
