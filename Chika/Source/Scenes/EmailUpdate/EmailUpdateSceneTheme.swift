//
//  EmailUpdateSceneTheme.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol EmailUpdateSceneTheme: class {

    var bgColor: UIColor { get }
    
    var labelFont: UIFont? { get }
    var labelTextColor: UIColor { get }
    
    var inputFont: UIFont? { get }
    var inputTextColor: UIColor { get }
    
    var barItemFont: UIFont? { get }
    
    var toastBGColor: UIColor { get }
    var toastTextColor: UIColor { get }
    var toastFont: UIFont? { get }
    
    var indicatorColor: UIColor { get }
}

extension EmailUpdateScene {
    
    class Theme: EmailUpdateSceneTheme {
    
        var bgColor: UIColor = .white
        
        var labelFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 16.0)
        var labelTextColor: UIColor = .black
        
        var inputFont: UIFont? = UIFont(name: "AvenirNext-Regular", size: 16.0)
        var inputTextColor: UIColor = .black
        
        var barItemFont: UIFont? = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        var toastBGColor: UIColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1.0)
        var toastTextColor: UIColor = .white
        var toastFont: UIFont? = UIFont(name: "AvenirNext-Bold", size: 14.0)
        
        var indicatorColor: UIColor = .black
    }
}
