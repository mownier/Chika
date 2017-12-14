//
//  SupportSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SupportSceneTheme: class {

    var bgColor: UIColor { get }
    
    var labelTextColor: UIColor { get }
    var labelFont: UIFont? { get }
}

extension SupportScene {
    
    class Theme: SupportSceneTheme {
    
        var bgColor: UIColor = .white
        
        var labelTextColor: UIColor = .black
        var labelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
    }
}
