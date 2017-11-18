//
//  InitialSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InitialSceneTheme: class {

    var bgColor: UIColor { get }
    var buttonFont: UIFont { get }
    
    var appNameLabelFont: UIFont { get }
    var appNameLabelTextColor: UIColor { get }
    
    var signInButtonTitleColor: UIColor { get }
    var signInButtonBGColor: UIColor { get }
    var signInBorderColor: UIColor { get }
    var signInBorderWidth: CGFloat { get }
    
    var registerButtonTittleColor: UIColor { get }
    var registerButtonBGColor: UIColor { get }
    var registerBorderColor: UIColor { get }
    var registerBorderWidth: CGFloat { get }
}

extension InitialScene {
    
    class Theme: InitialSceneTheme {
        
        var bgColor: UIColor = .white
        var buttonFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        
        var appNameLabelFont: UIFont = UIFont(name: "AvenirNext-Bold", size: 32.0)!
        var appNameLabelTextColor: UIColor = .black
        
        var signInButtonTitleColor: UIColor = .white
        var signInButtonBGColor: UIColor = .black
        var signInBorderColor: UIColor = .black
        var signInBorderWidth: CGFloat = 0
        
        var registerButtonTittleColor: UIColor = .black
        var registerButtonBGColor: UIColor = .white
        var registerBorderColor: UIColor = .black
        var registerBorderWidth: CGFloat = 1
    }
}
