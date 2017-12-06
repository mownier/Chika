//
//  ContactsSceneAddPopoverTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/6/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneAddPopoverTheme: class {

    var bgColor: UIColor { get }
    
    var buttonTextColor: UIColor { get }
    var buttonFont: UIFont? { get }
    var titleTextColor: UIColor { get }
    var titleFont: UIFont? { get }
    var inputTextColor: UIColor { get }
    var inputFont: UIFont? { get }
    var inputBGColor: UIColor { get }
}

extension ContactsSceneAddPopover {
    
    class Theme: ContactsSceneAddPopoverTheme {
        
        var bgColor: UIColor = UIColor(white: 0.97, alpha: 1.0)
        var buttonTextColor: UIColor = .black
        var buttonFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 12.0)
        var titleTextColor: UIColor = .black
        var titleFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        var inputTextColor: UIColor = .black
        var inputFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 14.0)
        var inputBGColor: UIColor = .white
    }
}
