//
//  RegisterSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol RegisterSceneFactory: class {
    
    func build() -> RegisterScene
}

extension RegisterScene {
    
    class Factory: RegisterSceneFactory {
        
        func build() -> RegisterScene {
            let scene = RegisterScene()
            return scene
        }
    }
}
