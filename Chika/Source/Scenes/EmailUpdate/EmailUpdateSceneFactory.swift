//
//  EmailUpdateSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneFactory: class {

    func build(withEmail email: String, delegate: EmailUpdateSceneDelegate?) -> UIViewController
}

extension EmailUpdateScene {
    
    class Factory: EmailUpdateSceneFactory {
    
        func build(withEmail email: String, delegate: EmailUpdateSceneDelegate?) -> UIViewController {
            let scene = EmailUpdateScene(email: email)
            scene.delegate = delegate
            return scene
        }
    }
}
