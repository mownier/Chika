//
//  ProfileSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileSceneTheme: class {
    
    var bgColor: UIColor { get }
    var avatarBGColor: UIColor { get }
    
    var labelTextColor: UIColor { get }
    var labelFont: UIFont? { get }
    var contentTextColor: UIColor { get }
    var contentFont: UIFont? { get }
    var destructiveTextColor: UIColor { get }
    
    var actionTintColor: UIColor { get }
    var actionBGColor: UIColor { get }
    
    var badgeBGColor: UIColor { get }
    var badgeTextColor: UIColor { get }
    var badgeFont: UIFont? { get }
}

extension ProfileScene {
    
    class Theme: ProfileSceneTheme {
        
        var bgColor: UIColor = .white
        var avatarBGColor: UIColor = .gray
        
        var labelTextColor: UIColor = .black
        var labelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var contentTextColor: UIColor = .black
        var contentFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 16.0)
        var destructiveTextColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        
        var actionTintColor: UIColor = .white
        var actionBGColor: UIColor = .black
        
        var badgeBGColor: UIColor = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)
        var badgeTextColor: UIColor = .white
        var badgeFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
    }
}
