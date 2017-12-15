//
//  SignOutSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignOutSceneFactory: class {

    func build(withDelegate: SignOutSceneDelegate?) -> UIViewController
}

extension SignOutScene {
    
    class Factory: SignOutSceneFactory {
        
        var title: String
        var message: String
        
        init(title: String = "Sign Out", message: String = "Are you sure?") {
            self.title = title
            self.message = message
        }
        
        func build(withDelegate delegate: SignOutSceneDelegate?) -> UIViewController {
            let scene = SignOutScene(title: title, message: message, preferredStyle: .actionSheet)
            scene.delegate = delegate
            scene.buildActions()
            return scene
        }
    }
}
