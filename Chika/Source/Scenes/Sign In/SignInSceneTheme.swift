//
//  SignInSceneTheme.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignInSceneTheme: class {
    
    var bgColor: UIColor { get }
    var inputFont: UIFont { get }
    var inputTintColor: UIColor { get }
    var inputTextColor: UIColor { get }
    var buttonFont: UIFont { get }
    var buttonTitleColor: UIColor { get }
    var buttonBGColor: UIColor { get }
    var titleLabelFont: UIFont { get }
    var titleLabelTextColor: UIColor { get }
    var indicatorColor: UIColor { get }
}

extension SignInScene {
    
    class Theme: SignInSceneTheme  {
        
        var bgColor: UIColor = .white
        var inputFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        var inputTintColor: UIColor = .black
        var inputTextColor: UIColor = .black
        var buttonFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        var buttonTitleColor: UIColor = .white
        var buttonBGColor: UIColor = .black
        var titleLabelFont: UIFont = UIFont(name: "AvenirNext-Bold", size: 32.0)!
        var titleLabelTextColor: UIColor = .black
        var indicatorColor: UIColor = .white
    }
}
