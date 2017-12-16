//
//  InboxSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InboxSceneTheme: class {

    var bgColor: UIColor { get }
    
    var chatTitleFont: UIFont? { get }
    var chatTitleTextColor: UIColor { get }
    var chatRecentMessageFont: UIFont? { get }
    var chatRecentMessageTextColor: UIColor { get }
    var chatTimeFont: UIFont? { get }
    var chatTimeTextColor: UIColor { get }
    
    var unreadMessaegCountFont: UIFont? { get }
    var unreadMessageCountTextColor: UIColor { get }
    var unreadMessageBGColor: UIColor { get }
    
    var onlineStatusColor: UIColor { get }
    
    var stripColor: UIColor { get }
    
    var badgeBGColor: UIColor { get }
}

extension InboxScene {
    
    class Theme: InboxSceneTheme {
        
        var bgColor: UIColor = .white
        
        var chatTitleFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var chatTitleTextColor: UIColor = .black
        var chatRecentMessageFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 14.0)
        var chatRecentMessageTextColor: UIColor = .gray
        var chatTimeFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 12.0)
        var chatTimeTextColor: UIColor = UIColor.gray
        
        var unreadMessaegCountFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 12.0)
        var unreadMessageCountTextColor: UIColor  = .white
        var unreadMessageBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        
        var onlineStatusColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var stripColor: UIColor = UIColor.gray.withAlphaComponent(0.25)
        
        var badgeBGColor: UIColor = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)
    }
}
