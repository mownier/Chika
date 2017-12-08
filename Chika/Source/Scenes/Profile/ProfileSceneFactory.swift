//
//  ProfileSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileSceneFactory: class {

    func build() -> UIViewController
}

extension ProfileScene {
    
    class Factory: ProfileSceneFactory {
        
        func build() -> UIViewController {
            let scene = ProfileScene()
            return scene
        }
    }
}
