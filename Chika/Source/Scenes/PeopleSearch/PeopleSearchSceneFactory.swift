//
//  PeopleSearchSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PeopleSearchSceneFactory: class {

    func build() -> UIViewController
}

extension PeopleSearchScene {
    
    class Factory: PeopleSearchSceneFactory {
    
        func build() -> UIViewController {
            let scene = PeopleSearchScene()
            return scene
        }
    }
}
