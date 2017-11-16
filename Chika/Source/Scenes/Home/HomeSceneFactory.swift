//
//  HomeSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol HomeSceneFactory {

    func build() -> HomeScene
}

extension HomeScene {
    
    class Factory: HomeSceneFactory {
        
        func build() -> HomeScene {
            let scene = HomeScene()
            return scene
        }
    }
}
