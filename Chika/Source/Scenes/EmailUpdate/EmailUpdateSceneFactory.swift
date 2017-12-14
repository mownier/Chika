//
//  EmailUpdateSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneFactory: class {

    func build(withDelegate: EmailUpdateSceneDelegate?) -> UIViewController
}

extension EmailUpdateScene {
    
    class Factory: EmailUpdateSceneFactory {
    
        func build(withDelegate delegate: EmailUpdateSceneDelegate?) -> UIViewController {
            let scene = EmailUpdateScene()
            scene.delegate = delegate
            return scene
        }
    }
}
