//
//  ConvoSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneTheme: class {

    var bgColor: UIColor { get }
}

extension ConvoScene {
    
    class Theme: ConvoSceneTheme {
        
        var bgColor: UIColor = .white
    }
}
