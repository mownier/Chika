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
    func didTapBack()
}

class SignInScene: UIViewController {
    
    var passInput: UITextField!
    var emailInput: UITextField!
    var goButton: UIButton!
    var titleLabel: UILabel!
    var backButton: UIButton!
    
    var worker: SignInSceneWorker!
    var theme: SignInSceneTheme!
    var flow: SignInSceneFlow!
    var waypoint: AppExitWaypoint!
    
    init(theme: SignInSceneTheme, worker: SignInSceneWorker, flow: SignInSceneFlow, waypoint: AppExitWaypoint) {
        self.worker = worker
        self.theme = theme
        self.flow = flow
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let worker = Worker()
        let flow = Flow()
        let waypoint = ExitWaypoint()
        self.init(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let theme = Theme()
        let worker = Worker()
        let flow = Flow()
        let waypoint = ExitWaypoint()
        self.init(theme: theme, worker: worker, flow: flow, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
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
        goButton.addTarget(self, action: #selector(self.didTapGo), for: .touchUpInside)
        goButton.backgroundColor = theme.buttonBGColor
        goButton.layer.cornerRadius = 4
        goButton.accessibilityLabel = "Sign In Button"
        
        titleLabel = UILabel()
        titleLabel.text = "Chika"
        titleLabel.textAlignment = .center
        titleLabel.font = theme.titleLabelFont
        titleLabel.textColor = theme.titleLabelTextColor
        titleLabel.accessibilityLabel = "Title Label"
        
        backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(self.didTapBack), for: .touchUpInside)
        backButton.tintColor = .black
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        backButton.accessibilityLabel = "Back Button"
        
        view.addSubview(passInput)
        view.addSubview(emailInput)
        view.addSubview(goButton)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        let topInset: CGFloat = 20 + spacing
        let inputHeight: CGFloat = 52
        let buttonHeight: CGFloat = 52
        let backButtonHeight: CGFloat = 52
        
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
        
        backButton.frame = CGRect(x: spacing * 2, y: topInset + spacing, width: backButtonHeight, height: backButtonHeight)
        backButton.layer.cornerRadius = backButtonHeight / 2
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
    
    func didTapBack() {
        let _ = waypoint.exit()
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
