//
//  RegisterScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol RegisterSceneInteraction: class {

    func didTapBack()
    func didTapGo()
}

class RegisterScene: UIViewController {

    var passInput: UITextField!
    var emailInput: UITextField!
    var goButton: UIButton!
    var titleLabel: UILabel!
    var indicator: UIActivityIndicatorView!

    var worker: RegisterSceneWorker!
    var theme: RegisterSceneTheme!
    var flow: RegisterSceneFlow!
    var waypoint: AppExitWaypoint!
    
    init(theme: RegisterSceneTheme, worker: RegisterSceneWorker, flow: RegisterSceneFlow, waypoint: AppExitWaypoint) {
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
        view.accessibilityLabel = "Register Scene View"
        
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
        goButton.setTitle("Register", for: .normal)
        goButton.setTitleColor(theme.buttonTitleColor, for: .normal)
        goButton.addTarget(self, action: #selector(self.didTapGo), for: .touchUpInside)
        goButton.backgroundColor = theme.buttonBGColor
        goButton.layer.cornerRadius = 4
        goButton.accessibilityLabel = "Register Button"
        
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
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back") , style: .plain, target: self, action: #selector(self.didTapBack))
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

extension RegisterScene: RegisterSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapGo() {
        indicator.startAnimating()
        passInput.resignFirstResponder()
        emailInput.resignFirstResponder()
        emailInput.isUserInteractionEnabled = false
        passInput.isUserInteractionEnabled = false
        goButton.isUserInteractionEnabled = false
        let email = emailInput.text
        let pass = passInput.text
        worker.register(email: email, pass: pass)
    }
}

extension RegisterScene: RegisterSceneWorkerOutput {
    
    func workerDidRegisterOK() {
        let _ = flow.goToHome()
    }
    
    func workerDidRegisterWithError(_ error: Error) {
        emailInput.isUserInteractionEnabled = true
        passInput.isUserInteractionEnabled = true
        goButton.isUserInteractionEnabled = true
        indicator.stopAnimating()
        flow.showError(error)
    }
}
