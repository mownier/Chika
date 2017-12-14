//
//  PasswordChangeSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PasswordChangeSceneFactory: class {

    func build() -> UIViewController
}

extension PasswordChangeScene {
    
    class Factory: PasswordChangeSceneFactory {
    
        func build() -> UIViewController {
            let scene = PasswordChangeScene()
            return scene
        }
    }
}
