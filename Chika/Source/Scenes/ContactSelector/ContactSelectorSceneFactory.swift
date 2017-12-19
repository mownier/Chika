//
//  ContactSelectorSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSelectorSceneFactory: class {

    func build(withDelegate delegate: ContactSelectorSceneDelegate?, excludedPersons: [Person]) -> UIViewController
}

extension ContactSelectorScene {
    
    class Factory: ContactSelectorSceneFactory {
    
        func build(withDelegate delegate: ContactSelectorSceneDelegate?, excludedPersons persons: [Person]) -> UIViewController {
            let scene = ContactSelectorScene(excludedPersons: persons)
            scene.delegate = delegate
            return scene
        }
    }
}
