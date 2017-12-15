//
//  SignOutSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignOutSceneTheme: class {

    var tintColor: UIColor { get }
}

extension SignOutScene {
    
    class Theme: SignOutSceneTheme {
        
        var tintColor: UIColor = .black
    }
}
