//
//  SupportSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SupportSceneFactory: class {

    func build() -> UIViewController
}

extension SupportScene {
    
    class Factory: SupportSceneFactory {
    
        func build() -> UIViewController {
            let scene = SupportScene()
            return scene
        }
    }
}
