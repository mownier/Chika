//
//  InitialSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InitialSceneFactory: class {
    
    func build() -> InitialScene
}

extension InitialScene {
    
    class Factory: InitialSceneFactory {
        
        func build() -> InitialScene {
            let scene = InitialScene()
            return scene
        }
    }
}
