//
//  SignInScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

class SignInScene: UIViewController {
    
    var passInput: UITextField!
    var emailInput: UITextField!
    var goButton: UIButton!
    var titleLabel: UILabel!
    var indicator: UIActivityIndicatorView!
    
    var flow: SignInSceneFlow!
    var theme: SignInSceneTheme!
    var worker: SignInSceneWorker!
    var interaction: SignInSceneInteraction!
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        view.accessibilityLabel = "Sign In Scene View"
        
        passInput = UITextField()
        passInput.font = theme.inputFont
        passInput.placeholder = "Password"
        passInput.isSecureTextEntry = true
        passInput.textAlignment = .center
        passInput.tintColor = theme.inputTintColor
        passInput.textColor = theme.inputTextColor
        passInput.layer.cornerRadius = 4
        passInput.layer.borderWidth = 1
        passInput.layer.borderColor = passInput.tintColor.cgColor
        passInput.autocapitalizationType = .none
        passInput.accessibilityLabel = "Pass Input"
        
        emailInput = UITextField()
        emailInput.font = theme.inputFont
        emailInput.placeholder = "Email"
        emailInput.textAlignment = .center
        emailInput.tintColor = theme.inputTintColor
        emailInput.textColor = theme.inputTextColor
        emailInput.layer.cornerRadius = 4
        emailInput.layer.borderWidth = 1
        emailInput.layer.borderColor = emailInput.tintColor.cgColor
        emailInput.autocapitalizationType = .none
        emailInput.accessibilityLabel = "Email Input"
        
        goButton = UIButton()
        goButton.titleLabel?.font = theme.buttonFont
        goButton.setTitle("Sign In", for: .normal)
        goButton.setTitleColor(theme.buttonTitleColor, for: .normal)
        goButton.addTarget(interaction, action: #selector(interaction.didTapGo), for: .touchUpInside)
        goButton.backgroundColor = theme.buttonBGColor
        goButton.layer.cornerRadius = 4
        goButton.accessibilityLabel = "Sign In Button"
        
        titleLabel = UILabel()
        titleLabel.text = "Chika"
        titleLabel.textAlignment = .center
        titleLabel.font = theme.titleLabelFont
        titleLabel.textColor = theme.titleLabelTextColor
        titleLabel.accessibilityLabel = "Title Label"
        
        indicator = UIActivityIndicatorView()
        indicator.color = theme.indicatorColor
        indicator.hidesWhenStopped = true
        
        view.addSubview(passInput)
        view.addSubview(emailInput)
        view.addSubview(goButton)
        view.addSubview(titleLabel)
        view.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back") , style: .plain, target: interaction, action: #selector(interaction.didTapBack))
        back.accessibilityLabel = "Back Button"
        navigationItem.leftBarButtonItem = back
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.y = view.statusBarFrame().height
        rect.origin.x = spacing * 2
        rect.size.width = view.bounds.width - spacing * 4
        rect.size.height = 52
        titleLabel.frame = rect
        
        rect.origin.y = rect.maxY + spacing * 2
        emailInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing * 2
        passInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing * 4
        goButton.frame = rect
        
        rect.size.width = goButton.frame.height
        rect.origin.x = goButton.frame.maxX - rect.width
        indicator.frame = rect
    }
}

extension SignInScene: SignInSceneWorkerOutput {
    
    func workerDidSignInOK() {
        let _ = flow.goToHome()
    }
    
    func workerDidSignInWithError(_ error: Swift.Error) {
        emailInput.isUserInteractionEnabled = true
        passInput.isUserInteractionEnabled = true
        goButton.isUserInteractionEnabled = true
        indicator.stopAnimating()
        flow.showError(error)
    }
}
