//
//  ContactSelectorSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSelectorSceneFactory: class {

    func build(withDelegate delegate: ContactSelectorSceneDelegate?) -> UIViewController
}

extension ContactSelectorScene {
    
    class Factory: ContactSelectorSceneFactory {
    
        func build(withDelegate delegate: ContactSelectorSceneDelegate?) -> UIViewController {
            let scene = ContactSelectorScene()
            scene.delegate = delegate
            return scene
        }
    }
}
