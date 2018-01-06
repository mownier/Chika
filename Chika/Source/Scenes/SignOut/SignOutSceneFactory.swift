//
//  SignOutSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol SignOutSceneFactory: class {

    func withTheme(_ theme: SignOutSceneTheme) -> SignOutSceneFactory & SceneFactory
    func withDelegate(_ delegate: SignOutSceneDelegate?) -> SignOutSceneFactory & SceneFactory
}

extension SignOutScene {
    
    class Factory: SignOutSceneFactory, SceneFactory {
        
        var theme: SignOutSceneTheme
        var delegate: SignOutSceneDelegate?
        
        var title: String
        var message: String
        
        init() {
            let theme = Theme()
            
            self.theme = theme
            
            self.title = "Sign Out"
            self.message = "Are you sure?"
        }
        
        func build() -> UIViewController {
            let scene = SignOutScene(title: title, message: message, preferredStyle: .actionSheet)
            scene.delegate = delegate
            scene.buildActions()
            return scene
        }
        
        func withTheme(_ aTheme: SignOutSceneTheme) -> SignOutSceneFactory & SceneFactory {
            theme = aTheme
            return self
        }
        
        func withDelegate(_ aDelegate: SignOutSceneDelegate?) -> SignOutSceneFactory & SceneFactory {
            delegate = aDelegate
            return self
        }
    }
}


