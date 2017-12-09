//
//  ContactRequestSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneTheme: class {

    var bgColor: UIColor { get }
}

extension ContactRequestScene {
    
    class Theme: ContactRequestSceneTheme {
        
        var bgColor: UIColor = .white
    }
}
