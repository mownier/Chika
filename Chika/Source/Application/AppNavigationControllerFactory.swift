//
//  AppNavigationControllerFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AppNavigationControllerFactory: class {

    func build(root: UIViewController) -> UINavigationController
}

protocol AppNavigationBarTheme: class {
    
    var shadowImage: UIImage? { get }
    var bgImage: UIImage? { get }
    var isTranslucent: Bool { get }
    var barTintColor: UIColor? { get }
    var tintColor: UIColor? { get }
}

extension UINavigationBar {
    
    struct Theme {
        
        class Default: AppNavigationBarTheme {
            
            var shadowImage: UIImage?
            var bgImage: UIImage?
            var isTranslucent: Bool = false
            var barTintColor: UIColor? = .white
            var tintColor: UIColor? = .black
        }
        
        class Empty: AppNavigationBarTheme {
            
            var shadowImage: UIImage? = UIImage()
            var bgImage: UIImage? = UIImage()
            var isTranslucent: Bool = true
            var barTintColor: UIColor?
            var tintColor: UIColor? = .black
        }
    }
}

extension UINavigationController {
    
    class Factory: AppNavigationControllerFactory {
        
        var navBarTheme: AppNavigationBarTheme
        
        init(navBarTheme: AppNavigationBarTheme = UINavigationBar.Theme.Default()) {
            self.navBarTheme = navBarTheme
        }
        
        func build(root: UIViewController) -> UINavigationController {
            let nav = UINavigationController(rootViewController: root)
            nav.navigationBar.isTranslucent = navBarTheme.isTranslucent
            nav.navigationBar.shadowImage = navBarTheme.shadowImage
            nav.navigationBar.setBackgroundImage(navBarTheme.bgImage, for: .default)
            nav.navigationBar.barTintColor = navBarTheme.barTintColor
            nav.navigationBar.tintColor = navBarTheme.tintColor
            return nav
        }
    }
}
