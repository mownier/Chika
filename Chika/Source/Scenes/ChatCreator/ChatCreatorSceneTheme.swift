//
//  ChatCreatorSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneTheme: class {

    var bgColor: UIColor { get }
    
    var avatarBGColor: UIColor { get }
    
    var inputBGColor: UIColor { get }
    var inputTextColor: UIColor { get }
    var inputFont: UIFont? { get }
    var inputStripColor: UIColor { get }
    var inputButtonTintColor: UIColor { get }
    var inputCancelButtonTextColor: UIColor { get }
    var inputCancelButtonFont: UIFont? { get }
    
    var contactNameTextColor: UIColor { get }
    var contactNameFont: UIFont? { get }
    
    var labelTextColor: UIColor { get }
    var labelFont: UIFont? { get }
    
    var barItemFont: UIFont? { get }
    
    var selectBGColor: UIColor { get }
    var selectTintColor: UIColor { get }
    var selectBorderColor: UIColor { get }
    
    var indicatorColor: UIColor { get }
}

extension ChatCreatorScene {
    
    class Theme: ChatCreatorSceneTheme {
    
        var bgColor: UIColor = .white
        
        var avatarBGColor: UIColor = .gray
        
        var inputBGColor: UIColor = .white
        var inputTextColor: UIColor = .black
        var inputFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var inputStripColor: UIColor = UIColor.gray.withAlphaComponent(0)
        var inputButtonTintColor: UIColor = .black
        var inputCancelButtonFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var inputCancelButtonTextColor: UIColor = .gray
        
        var contactNameTextColor: UIColor = .black
        var contactNameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        var labelTextColor: UIColor = .black
        var labelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        var barItemFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        var selectBGColor: UIColor = .white
        var selectBorderColor: UIColor = .black
        var selectTintColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var indicatorColor: UIColor = .black
    }
}
