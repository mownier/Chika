//
//  ContactChatSettingSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneTheme: class {
    
    var bgColor: UIColor { get }
    
    var avatarBGColor: UIColor { get }
    
    var titleTextColor: UIColor { get }
    var titleFont: UIFont? { get }
    
    var destructiveTextColor: UIColor { get }
    var positiveTextColor: UIColor { get }
    
    var createBGColor: UIColor { get }
    var createTitleTextColor: UIColor { get }
    var createTitleFont: UIFont? { get }
}

extension ContactChatSettingScene {
    
    class Theme: ContactChatSettingSceneTheme {
        
        var bgColor: UIColor = .white
        
        var avatarBGColor: UIColor = .gray
        
        var titleTextColor: UIColor = .black
        var titleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 20.0)
        
        var destructiveTextColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        var positiveTextColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var createBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        var createTitleTextColor: UIColor = .white
        var createTitleFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 14.0)
    }
}

