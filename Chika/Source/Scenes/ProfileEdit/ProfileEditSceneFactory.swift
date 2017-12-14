//
//  ProfileEditSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileEditSceneFactory: class {

    func buildWith(person: Person, delegate: ProfileEditSceneDelegate?) -> UIViewController
}

extension ProfileEditScene {
    
    class Factory: ProfileEditSceneFactory {
    
        func buildWith(person: Person, delegate: ProfileEditSceneDelegate?) -> UIViewController {
            let scene = ProfileEditScene(person: person)
            scene.delegate = delegate
            return scene
        }
    }
}
