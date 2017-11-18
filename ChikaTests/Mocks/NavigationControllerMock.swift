//
//  NavigationControllerMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class NavigationControllerMock: UINavigationController {

    weak var pushedScene: UIViewController?
    var scenes: [UIViewController] = []
    
    override var topViewController: UIViewController? {
        return scenes.last
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if scenes.count == 0 {
            scenes.append(contentsOf: viewControllers)
        }
        scenes.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        guard scenes.count > 1  else {
            return nil
        }
        
        let _ = super.popViewController(animated: animated)
        return scenes.removeLast()
    }
}
