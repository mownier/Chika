//
//  HomeSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol HomeSceneTheme: class {

    var tabBarTintColor: UIColor { get }
    var tabBarBarTintColor: UIColor { get }
    var tabBarIsTranslucent: Bool { get }
}

extension HomeScene {
    
    class Theme: HomeSceneTheme {
        
        var tabBarTintColor: UIColor = .black
        var tabBarBarTintColor: UIColor = .white
        var tabBarIsTranslucent: Bool = false
    }
}
