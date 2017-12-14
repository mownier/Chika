//
//  EmailUpdateSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem)
}

extension EmailUpdateScene {
    
    class Setup: EmailUpdateSceneSetup {
    
        func formatTitle(in navigationItem: UINavigationItem) {
            navigationItem.title = "Update Email"
        }
    }
}
