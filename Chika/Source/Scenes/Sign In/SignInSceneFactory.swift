//
//  SignInSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol SignInSceneFactory: class {

    func build() -> SignInScene
}

extension SignInScene {
    
    class Factory: SignInSceneFactory {
        
        func build() -> SignInScene {
            let scene = SignInScene()
            return scene
        }
    }
}
