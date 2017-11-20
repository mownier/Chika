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
    
    init(theme: HomeSceneTheme, setup: HomeSceneTabSetup) {
        self.theme = theme
        self.setup = setup
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let setup = TabSetup()
        self.init(theme: theme, setup: setup)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        tabBar.tintColor = theme.tabBarTintColor
        tabBar.barTintColor = theme.tabBarBarTintColor
        tabBar.isTranslucent = theme.tabBarIsTranslucent
        
        viewControllers = setup.subscenes
    }
}
