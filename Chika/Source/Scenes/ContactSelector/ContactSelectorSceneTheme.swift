//
//  ContactSelectorSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSelectorSceneTheme: class {

    var bgColor: UIColor { get }
    
    var avatarBGColor: UIColor { get }
    var contactNameTextColor: UIColor { get }
    var contactNameFont: UIFont? { get }
    
    var barItemFont: UIFont? { get }
    
    var selectBGColor: UIColor { get }
    var selectTintColor: UIColor { get }
    var selectBorderColor: UIColor { get }
    
    var emptyTitleTextColor: UIColor { get }
    var emptyTitleFont: UIFont? { get }
}

extension ContactSelectorScene {
    
    class Theme: ContactSelectorSceneTheme {
    
        var bgColor: UIColor = .white
        
        var avatarBGColor: UIColor = .gray
        var contactNameTextColor: UIColor = .black
        var contactNameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        var barItemFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        var selectBGColor: UIColor = .white
        var selectBorderColor: UIColor = .black
        var selectTintColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var emptyTitleTextColor: UIColor = .black
        var emptyTitleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
    }
}
