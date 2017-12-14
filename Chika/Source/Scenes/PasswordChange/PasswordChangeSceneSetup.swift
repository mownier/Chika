//
//  PasswordChangeSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PasswordChangeSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem)
}

extension PasswordChangeScene {
    
    class Setup: PasswordChangeSceneSetup {
    
        func formatTitle(in navigationItem: UINavigationItem) {
            navigationItem.title = "Update Password"
        }
    }
}
