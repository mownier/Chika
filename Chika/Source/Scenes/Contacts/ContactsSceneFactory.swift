//
//  ContactsSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneFactory: class {

    func build() -> UIViewController
}

extension ContactsScene {
    
    class Factory: ContactsSceneFactory {
        
        func build() -> UIViewController {
            let scene = ContactsScene()
            return scene
        }
    }
}
