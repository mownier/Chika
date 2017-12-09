//
//  ContactRequestSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneFactory: class {

    func build() -> UIViewController
}

extension ContactRequestScene {
    
    class Factory: ContactRequestSceneFactory {
    
        func build() -> UIViewController {
            let scene = ContactRequestScene()
            return scene
        }
    }
}
