//
//  ContactRequestSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneSetup: class {

    func formatTitle(in navigationItem: UINavigationItem) -> Bool
}

extension ContactRequestScene {
    
    class Setup: ContactRequestSceneSetup {
        
        weak var theme: ContactRequestSceneTheme!
        
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {            
            navigationItem.title = "Contact Requests"
            return true
        }
    }
}
