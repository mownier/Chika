//
//  SignInScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol SignInSceneInteraction: class {
    
    func didTapGo()
}

class SignInScene: UIViewController {
    
    var passInput: UITextField!
    var emailInput: UITextField!
    var goButton: UIButton!
    var titleLabel: UILabel!
    
    var worker: SignInSceneWorker!
    var theme: SignInSceneTheme!
    var flow: SignInSceneFlow!
    
    init(theme: SignInSceneTheme, worker: SignInSceneWorker, flow: SignInSceneFlow) {
        self.worker = worker
        self.theme = theme
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let worker = Worker()
        let flow = Flow()
        self.init(theme: theme, worker: worker, flow: flow)
        worker.output = self
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let theme = Theme()
        let worker = Worker()
        let flow = Flow()
        self.init(theme: theme, worker: worker, flow: flow)
        worker.output = self
        flow.scene = self
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
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
        
        goButton = UIButton()
        goButton.titleLabel?.font = theme.buttonFont
        goButton.setTitle("Sign In", for: .normal)
        goButton.setTitleColor(theme.buttonTitleColor, for: .normal)
        goButton.addTarget(self, action: #selector(self.didTapGo), for: .touchUpInside)
        goButton.backgroundColor = theme.buttonBGColor
        goButton.layer.cornerRadius = 4
        
        titleLabel = UILabel()
        titleLabel.text = "Chika"
        titleLabel.textAlignment = .center
        titleLabel.font = theme.titleLabelFont
        titleLabel.textColor = theme.titleLabelTextColor
        
        view.addSubview(passInput)
        view.addSubview(emailInput)
        view.addSubview(goButton)
        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        let topInset: CGFloat = 20 + spacing
        let inputHeight: CGFloat = 52
        let buttonHeight: CGFloat = 52
        
        var (rect, rem) = view.bounds.divided(atDistance: topInset, from: .minYEdge)
        
        (rect, rem) = rem.divided(atDistance: inputHeight, from: .minYEdge)
        titleLabel.frame = rect.insetBy(dx: spacing, dy: 0)
        
        (rect, rem) = rem.divided(atDistance: spacing * 2, from: .minYEdge)
        (rect, rem) = rem.divided(atDistance: inputHeight, from: .minYEdge)
        emailInput.frame = rect.insetBy(dx: spacing * 2, dy: 0)

        (rect, rem) = rem.divided(atDistance: spacing, from: .minYEdge)
        (rect, rem) = rem.divided(atDistance: inputHeight, from: .minYEdge)
        passInput.frame = rect.insetBy(dx: spacing * 2, dy: 0)
        
        (rect, rem) = rem.divided(atDistance: spacing * 4, from: .minYEdge)
        (rect, rem) = rem.divided(atDistance: buttonHeight, from: .minYEdge)
        goButton.frame = rect.insetBy(dx: spacing * 2, dy: 0)
    }
}

extension SignInScene: SignInSceneInteraction {
    
    func didTapGo() {
        passInput.resignFirstResponder()
        emailInput.resignFirstResponder()
        let email = emailInput.text
        let pass = passInput.text
        passInput.text = ""
        emailInput.text = ""
        worker.signIn(email: email, pass: pass)
    }
}

extension SignInScene: SignInSceneWorkerOutput {
    
    func workerDidSignInOK() {
        let _ = flow.goToHome()
    }
    
    func workerDidSignInWithError(_ error: Error) {
        flow.showError(error)
    }
}
