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
    
    var chatTitleLabelFont: UIFont? { get }
    var chatRecentMessageLabelFont: UIFont? { get }
}

extension InboxScene {
    
    class Theme: InboxSceneTheme {
        
        var bgColor: UIColor = .white
        var chatTitleLabelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var chatRecentMessageLabelFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 14.0)
    }
}
