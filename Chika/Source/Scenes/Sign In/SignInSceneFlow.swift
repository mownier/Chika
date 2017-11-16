//
//  SignInSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignInSceneFlow: class {
    
    func goToHome() -> Bool
    func showError(_ error: Error)
}

extension SignInScene {
    
    class Flow: SignInSceneFlow {
        
        weak var scene: UIViewController?
        var homeSceneFlow: HomeSceneFlow
        
        init(homeSceneFlow: HomeSceneFlow = HomeScene.Flow()) {
            self.homeSceneFlow = homeSceneFlow
        }
        
        func goToHome() -> Bool {
            guard let scene = scene else {
                return false
            }
            
            if scene.isBeingPresented {
                scene.dismiss(animated: true, completion: nil)
            }
            
            return homeSceneFlow.connect(from: scene)
        }
        
        func showError(_ error: Error) {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            scene?.present(alert, animated: true, completion: nil)
        }
    }
}
