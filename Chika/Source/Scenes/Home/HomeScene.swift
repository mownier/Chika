//
//  HomeScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class HomeScene: UITabBarController {

    var theme: HomeSceneTheme!
    var setup: HomeSceneTabSetup!
    
    override func loadView() {
        super.loadView()
        
        tabBar.tintColor = theme.tabBarTintColor
        tabBar.barTintColor = theme.tabBarBarTintColor
        tabBar.isTranslucent = theme.tabBarIsTranslucent
        
        viewControllers = setup.subscenes
    }
}
