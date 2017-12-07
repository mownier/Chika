//
//  ContactsSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneTheme: class {

    var bgColor: UIColor { get }
    var searchBGColor: UIColor { get }
    var searchInputTextColor: UIColor { get }
    var searchInputFont: UIFont? { get }
    var searchStripColor: UIColor { get }
    var searchButtonTintColor: UIColor { get }
    var searchCancelButtonTextColor: UIColor { get }
    var searchCancelButtonFont: UIFont? { get }
    var avatarBGColor: UIColor { get }
    var contactNameTextColor: UIColor { get }
    var contactNameFont: UIFont? { get }
    var onlineStatusColor: UIColor { get }
    var searchResultEmptyTitleTextColor: UIColor { get }
    var searchResultEmptyTitleFont: UIFont?  { get }
    var addActionBGColor: UIColor { get }
    var addActionOkayBGColor: UIColor { get }
    var addActionFailedBGColor: UIColor { get }
    var addActionActiveBGColor: UIColor { get }
    var addActionTextColor: UIColor { get }
    var addActionFont: UIFont? { get }
}

extension ContactsScene {
    
    class Theme: ContactsSceneTheme {
        
        var bgColor: UIColor = .white
        var searchBGColor: UIColor = .white
        var searchInputTextColor: UIColor = .black
        var searchInputFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var searchStripColor: UIColor = UIColor.gray.withAlphaComponent(0)
        var searchButtonTintColor: UIColor = .black
        var searchCancelButtonFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var searchCancelButtonTextColor: UIColor = .gray
        var avatarBGColor: UIColor = .gray
        var contactNameTextColor: UIColor = .black
        var contactNameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var onlineStatusColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        var searchResultEmptyTitleTextColor: UIColor = .black
        var searchResultEmptyTitleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var addActionBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        var addActionOkayBGColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
        var addActionFailedBGColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        var addActionActiveBGColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        var addActionFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 14.0)
        var addActionTextColor: UIColor = .white
    }
}
