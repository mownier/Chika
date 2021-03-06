//
//  InitialScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol InitialSceneInteraction: class {
    
    func didTapSignIn()
    func didTapRegister()
}

class InitialScene: UIViewController {

    var appNameLabel: UILabel!
    
    var signInButton: UIButton!
    var registerButton: UIButton!
    
    var theme: InitialSceneTheme!
    var flow: InitialSceneFlow!
    
    init(theme: InitialSceneTheme, flow: InitialSceneFlow) {
        self.theme = theme
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let flow = Flow()
        self.init(theme: Theme(), flow: flow)
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let flow = Flow()
        self.init(theme: Theme(), flow: flow)
        flow.scene = self
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(theme.signInButtonTitleColor, for: .normal)
        signInButton.titleLabel?.font = theme.buttonFont
        signInButton.backgroundColor = theme.signInButtonBGColor
        signInButton.layer.borderColor = theme.signInBorderColor.cgColor
        signInButton.layer.borderWidth = theme.signInBorderWidth
        signInButton.layer.cornerRadius = 4
        signInButton.addTarget(self, action: #selector(self.didTapSignIn), for: .touchUpInside)
        
        registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(theme.registerButtonTittleColor, for: .normal)
        registerButton.titleLabel?.font = theme.buttonFont
        registerButton.backgroundColor = theme.registerButtonBGColor
        registerButton.layer.borderColor = theme.registerBorderColor.cgColor
        registerButton.layer.borderWidth = theme.registerBorderWidth
        registerButton.layer.cornerRadius = 4
        registerButton.addTarget(self, action: #selector(self.didTapRegister), for: .touchUpInside)
        
        appNameLabel = UILabel()
        appNameLabel.text = "Chika"
        appNameLabel.textAlignment = .center
        appNameLabel.font = theme.appNameLabelFont
        appNameLabel.textColor = theme.appNameLabelTextColor
        
        view.addSubview(signInButton)
        view.addSubview(registerButton)
        view.addSubview(appNameLabel)
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.size.width = view.bounds.width - spacing * 4
        rect.size.height = 52
        rect.origin.y = view.bounds.height - spacing * 5 - rect.height
        registerButton.frame = rect
        
        rect.origin.y -= (spacing + rect.height)
        signInButton.frame = rect
        
        rect.origin.y = view.statusBarFrame().height
        appNameLabel.frame = rect
    }
}

extension InitialScene: InitialSceneInteraction {
    
    func didTapSignIn() {
        let _ = flow.goToSignIn()
    }
    
    func didTapRegister() {
        let _ = flow.goToRegister()
    }
}
