//
//  ChatSettingSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneTheme: class {

    var bgColor: UIColor { get }
    
    var avatarBGColor: UIColor { get }
    var contactNameTextColor: UIColor { get }
    var contactNameFont: UIFont? { get }
    var onlineStatusColor: UIColor { get }
    
    var optionFont: UIFont? { get }
    var optionTextColor: UIColor { get }
    
    var headerBGColor: UIColor { get }
    var headerTextColor: UIColor { get }
    var headerFont: UIFont? { get }
    
    var tableHeaderTitleTextColor: UIColor { get }
    var tableHeaderTitleFont: UIFont? { get }
    var tableHeaderCreatorTextColor: UIColor { get }
    var tableHeaderCreatorFont: UIFont? { get }
    
    var destructiveTextColor: UIColor { get }
    var positiveTextColor: UIColor { get }
}

extension ChatSettingScene {
    
    class Theme: ChatSettingSceneTheme {
    
        var bgColor: UIColor = .white
        
        var avatarBGColor: UIColor = .gray
        var contactNameTextColor: UIColor = .black
        var contactNameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var onlineStatusColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var optionFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var optionTextColor: UIColor = .black
        
        var headerBGColor: UIColor = .white
        var headerTextColor: UIColor = .gray
        var headerFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 12.0)
        
        var tableHeaderTitleTextColor: UIColor = .black
        var tableHeaderTitleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 20.0)
        var tableHeaderCreatorTextColor: UIColor = .gray
        var tableHeaderCreatorFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        var destructiveTextColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        var positiveTextColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
    }
}
