//
//  InitialSceneInteraction.swift
//  Chika
//
//  Created by Mounir Ybanez on 1/6/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

@objc protocol InitialSceneInteraction: class {
    
    func didTapSignIn()
    func didTapRegister()
}

extension InitialScene {
    
    class Interaction: InitialSceneInteraction {
        
        var flow: InitialSceneFlow
        
        init(flow: InitialSceneFlow) {
            self.flow = flow
        }
        
        func didTapSignIn() {
            let _ = flow.goToSignIn()
        }
        
        func didTapRegister() {
            let _ = flow.goToRegister()
        }
    }
}
