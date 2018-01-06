//
//  ProfileSceneDelegate.swift
//  Chika
//
//  Created by Mounir Ybanez on 1/6/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import TNCore

extension ProfileScene {

    enum Delegate {
        
        class SignOut: SignOutSceneDelegate {
            
            var flow: ProfileSceneFlow
            
            init(flow: ProfileSceneFlow) {
                self.flow = flow
            }
            
            func signOutSceneWillSignOut() {
                let _ = flow.goToInitial()
            }
        }
    }
}
