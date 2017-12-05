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
    var avatarBGColor: UIColor { get }
    var contactNameTextColor: UIColor { get }
    var contactNameFont: UIFont? { get }
    var onlineStatusColor: UIColor { get }
}

extension ContactsScene {
    
    class Theme: ContactsSceneTheme {
        
        var bgColor: UIColor = .white
        var searchBGColor: UIColor = .white
        var avatarBGColor: UIColor = .gray
        var contactNameTextColor: UIColor = .black
        var contactNameFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var onlineStatusColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
    }
}
