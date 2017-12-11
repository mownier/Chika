//
//  ContactRequestSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneTheme: class {

    var bgColor: UIColor { get }
    var avatarBGColor: UIColor { get }
    var nameTextColor: UIColor { get }
    var nameFont: UIFont? { get }
    var headerBGColor: UIColor { get }
    var headerTextColor: UIColor { get }
    var headerFont: UIFont? { get }
    var actionOKColor: UIColor { get }
    var actionDestructiveColor: UIColor { get }
    var actionShowMessageColor: UIColor { get }
    var actionFont: UIFont? { get }
    var messageFont: UIFont? { get }
    var messageTextColor: UIColor { get }
    var statusFont: UIFont? { get }
    var statusTextColor: UIColor { get }
    var statusBGColor: UIColor { get }
}

extension ContactRequestScene {
    
    class Theme: ContactRequestSceneTheme {
        
        var bgColor: UIColor = .white
        var avatarBGColor: UIColor = .gray
        var nameTextColor: UIColor = .black
        var nameFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var headerBGColor: UIColor = .white
        var headerTextColor: UIColor = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)
        var headerFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var actionOKColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        var actionDestructiveColor: UIColor = UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        var actionShowMessageColor: UIColor = .lightGray
        var actionFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 14.0)
        var messageFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 14.0)
        var messageTextColor: UIColor = .gray
        var statusFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 10.0)
        var statusTextColor: UIColor = .gray
        var statusBGColor: UIColor = .clear
    }
}
