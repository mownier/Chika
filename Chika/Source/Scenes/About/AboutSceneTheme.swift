//
//  AboutSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AboutSceneTheme: class {

    var bgColor: UIColor { get }
    
    var labelTextColor: UIColor { get }
    var labelFont: UIFont? { get }
    
    var contentTextColor: UIColor { get }
    var contentFont: UIFont? { get }
}

extension AboutScene {
    
    class Theme: AboutSceneTheme {
    
        var bgColor: UIColor = .white
    
        var labelTextColor: UIColor = .black
        var labelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        var contentTextColor: UIColor = .black
        var contentFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 16.0)
    }
}
