//
//  HomeSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension HomeScene {
    
    class RootWaypoint: AppRootWaypoint {
        
        var home: HomeSceneFactory
        
        init(home: HomeSceneFactory = HomeScene.Factory()) {
            self.home = home
        }
        
        func makeRoot(from window: UIWindow?) -> Bool {
            guard let window = window else {
                return false
            }
            
            let scene = home.build()
            window.rootViewController = scene
            return true
        }
    }
}
