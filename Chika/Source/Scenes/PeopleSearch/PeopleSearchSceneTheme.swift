//
//  PeopleSearchSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PeopleSearchSceneTheme: class {

    var bgColor: UIColor { get }
    
    var inputBGColor: UIColor { get }
    var inputTextColor: UIColor { get }
    var inputFont: UIFont? { get }
    var inputStripColor: UIColor { get }
    var inputButtonTintColor: UIColor { get }
    var inputCancelButtonTextColor: UIColor { get }
    var inputCancelButtonFont: UIFont? { get }
    
    var emptyTitleTextColor: UIColor { get }
    var emptyTitleFont: UIFont?  { get }
    
    var avatarBGColor: UIColor { get }
    var nameTextColor: UIColor { get }
    var nameFont: UIFont? { get }
    var onlineStatusColor: UIColor { get }
    
    var addActionBGColor: UIColor { get }
    var addActionOkayBGColor: UIColor { get }
    var addActionFailedBGColor: UIColor { get }
    var addActionActiveBGColor: UIColor { get }
    var addActionPendingBGColor: UIColor { get }
    var addActionTextColor: UIColor { get }
    var addActionFont: UIFont? { get }
}

extension PeopleSearchScene {
    
    class Theme: PeopleSearchSceneTheme {
        
        var bgColor: UIColor = .white
        
        var inputBGColor: UIColor = .white
        var inputTextColor: UIColor = .black
        var inputFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var inputStripColor: UIColor = UIColor.gray.withAlphaComponent(0)
        var inputButtonTintColor: UIColor = .black
        var inputCancelButtonFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var inputCancelButtonTextColor: UIColor = .gray
        
        var emptyTitleTextColor: UIColor = .black
        var emptyTitleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        var avatarBGColor: UIColor = .gray
        var nameTextColor: UIColor = .black
        var nameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var onlineStatusColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        
        var addActionBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        var addActionOkayBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        var addActionFailedBGColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        var addActionActiveBGColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        var addActionPendingBGColor: UIColor = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)
        var addActionFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 14.0)
        var addActionTextColor: UIColor = .white
    }
}
