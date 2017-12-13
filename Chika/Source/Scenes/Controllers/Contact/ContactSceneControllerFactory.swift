//
//  ContactSceneControllerFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSceneControllerFactory: class {
    
    func build() -> UIViewController
}

extension ContactSceneController {
    
    struct SubsceneFactory {
        
        var contacts: ContactsSceneFactory
        var peopleSearch: PeopleSearchSceneFactory
    }
    
    class Factory: ContactSceneControllerFactory {
        
        func build() -> UIViewController {
            let scene = ContactSceneController()
            return scene
        }
    }
}
