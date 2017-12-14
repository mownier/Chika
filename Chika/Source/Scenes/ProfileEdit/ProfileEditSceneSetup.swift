//
//  ProfileEditSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileEditSceneSetup: class {

    func formatTitle(in navigationItem: UINavigationItem)
}

extension ProfileEditScene {
    
    class Setup: ProfileEditSceneSetup {
        
        func formatTitle(in navigationItem: UINavigationItem) {
            navigationItem.title = "Edit Profile"
        }
    }
}
