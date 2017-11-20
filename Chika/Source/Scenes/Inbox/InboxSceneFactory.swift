//
//  InboxSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InboxSceneFactory: class {

    func build() -> UIViewController
}

extension InboxScene {
    
    class Factory: InboxSceneFactory {
        
        func build() -> UIViewController {
            let scene = InboxScene()
            return scene
        }
    }
}
