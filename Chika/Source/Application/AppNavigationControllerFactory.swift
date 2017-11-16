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

extension UINavigationController {
    
    class Factory: AppNavigationControllerFactory {
        
        func build(root: UIViewController) -> UINavigationController {
            return UINavigationController(rootViewController: root)
        }
    }
}
