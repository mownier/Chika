//
//  RegisterSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol RegisterSceneFlow: class {
    
    func goToHome() -> Bool
    func showError(_ error: Swift.Error)
}

extension RegisterScene {
    
    class Flow: RegisterSceneFlow {
        
        class Factory {
            
            var home: HomeSceneFactory & SceneFactory {
                return HomeScene.Factory()
            }
        }
        
        class Theme {
            
            var home: HomeSceneTheme {
                return HomeScene.Theme()
            }
        }
        
        weak var scene: UIViewController?
        var factory: Factory
        var theme: Theme
        
        init() {
            self.factory = Factory()
            self.theme = Theme()
        }
        
        func goToHome() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            let homeScene = factory.home.build()
            let waypoint = WindowWaypointSource()
            return waypoint.withWindow(scene.view.window).withScene(homeScene).makeRoot()
        }
        
        func showError(_ error: Swift.Error) {
            guard let scene = scene else {
                return
            }
            
            let waypoint = PresentWaypointSource()
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            let _ = waypoint.withScene(alert).enter(from: scene)
        }
    }
}
