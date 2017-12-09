//
//  ContactRequestSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneFlow: class {

}

extension ContactRequestScene {
    
    class Flow: ContactRequestSceneFlow {
    
        weak var scene: UIViewController?
    }
}
