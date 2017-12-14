//
//  AboutSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AboutSceneFactory: class {

    func build() -> UIViewController
}

extension AboutScene {
    
    class Factory: AboutSceneFactory {
    
        func build() -> UIViewController {
            let scene = AboutScene()
            return scene
        }
    }
}
