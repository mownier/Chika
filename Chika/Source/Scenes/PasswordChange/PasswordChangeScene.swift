//
//  PasswordChangeScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol PasswordChangeSceneInteraction: class {
    
    func didTapBack()
    func didTapUpdate()
}

class PasswordChangeScene: UIViewController {
    
    var newPassLabel: UILabel!
    var newPassInput: UITextField!
    var oldPassLabel: UILabel!
    var oldPassInput: UITextField!
    var currEmailLabel: UILabel!
    var currEmailInput: UITextField!
    
    var toast: UILabel!
    
    var theme: PasswordChangeSceneTheme
    var worker: PasswordChangeSceneWorker
    var setup: PasswordChangeSceneSetup
    var waypoint: TNCore.ExitWaypoint
    
    init(theme: PasswordChangeSceneTheme,
        worker: PasswordChangeSceneWorker,
        setup: PasswordChangeSceneSetup,
        waypoint: TNCore.ExitWaypoint) {
        self.theme = theme
        self.worker = worker
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let worker = Worker()
        let setup = Setup()
        let waypoint = PasswordChangeScene.ExitWaypoint()
        self.init(theme: theme, worker: worker, setup: setup, waypoint: waypoint)
        worker.output = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        newPassInput = UITextField()
        newPassInput.font = theme.inputFont
        newPassInput.textColor = theme.inputTextColor
        newPassInput.autocapitalizationType = .none
        newPassInput.autocorrectionType = .no
        newPassInput.tintColor = theme.inputTextColor
        newPassInput.isSecureTextEntry = true
        
        oldPassInput = UITextField()
        oldPassInput.font = theme.inputFont
        oldPassInput.textColor = theme.inputTextColor
        oldPassInput.autocapitalizationType = .none
        oldPassInput.autocorrectionType = .no
        oldPassInput.tintColor = theme.inputTextColor
        oldPassInput.isSecureTextEntry = true
        
        currEmailInput = UITextField()
        currEmailInput.font = theme.inputFont
        currEmailInput.textColor = theme.inputTextColor
        currEmailInput.autocapitalizationType = .none
        currEmailInput.autocorrectionType = .no
        currEmailInput.tintColor = theme.inputTextColor
        
        newPassLabel = UILabel()
        newPassLabel.font = theme.labelFont
        newPassLabel.textColor = theme.labelTextColor
        newPassLabel.text = "New Password"
        
        oldPassLabel = UILabel()
        oldPassLabel.font = theme.labelFont
        oldPassLabel.textColor = theme.labelTextColor
        oldPassLabel.text = "Current Password"
        
        currEmailLabel = UILabel()
        currEmailLabel.font = theme.labelFont
        currEmailLabel.textColor = theme.labelTextColor
        currEmailLabel.text = "Current Email"
        
        toast = UILabel()
        toast.backgroundColor = theme.toastBGColor
        toast.textColor = theme.toastTextColor
        toast.font = theme.toastFont
        toast.textAlignment = .center
        
        view.addSubview(newPassInput)
        view.addSubview(newPassLabel)
        view.addSubview(oldPassInput)
        view.addSubview(oldPassLabel)
        view.addSubview(currEmailInput)
        view.addSubview(currEmailLabel)
        view.addSubview(toast)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        changeToUpdateBarItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        newPassInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.size.width = view.bounds.width - rect.minX
        rect.size.height = 32
        rect.origin.y = spacing * 2
        newPassLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = 36
        newPassInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing
        rect.size.height = newPassLabel.frame.height
        oldPassLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = newPassLabel.frame.height
        oldPassInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing
        rect.size.height = newPassLabel.frame.height
        currEmailLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = newPassLabel.frame.height
        currEmailInput.frame = rect
    }
    
    func changeToIndicatorBarItem() {
        let indicator = UIActivityIndicatorView()
        indicator.color = theme.indicatorColor
        indicator.startAnimating()
        let barItem = UIBarButtonItem(customView: indicator)
        navigationItem.rightBarButtonItem = barItem
    }
    
    func changeToUpdateBarItem() {
        let save = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(self.didTapUpdate))
        navigationItem.rightBarButtonItem = save
        
        if let font = theme.barItemFont {
            save.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
    }
    
    func showToast(withText text: String) {
        toast.text = text
        var rect = CGRect.zero
        rect.size.width = view.bounds.width
        rect.size.height = 40
        rect.origin.y = -rect.height
        toast.frame = rect
        let hideAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) { [weak self] in
            self?.toast.frame.origin.y = -rect.height
        }
        let showAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) { [weak self] in
            self?.toast.frame.origin.y = 0
        }
        showAnimator.addCompletion { position in
            switch position {
            case .end:
                hideAnimator.startAnimation(afterDelay: 1.75)
                
            default:
                break
            }
        }
        showAnimator.startAnimation()
    }
    
    func showError(withMessage msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension PasswordChangeScene: PasswordChangeSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapUpdate() {
        changeToIndicatorBarItem()
        let newPass: String = newPassInput.text ?? ""
        let currPass: String = oldPassInput.text ?? ""
        let currEmail: String = currEmailInput.text ?? ""
        worker.changePassword(withNew: newPass, currentPassword: currPass, currentEmail: currEmail)
    }
}

extension PasswordChangeScene: PasswordChangeSceneWorkerOutput {

    func workerDidChangePassword() {
        changeToUpdateBarItem()
        showToast(withText: "PASSWORD CHANGED")
    }
    
    func workerDidChangePasswordWithError(_ error: Swift.Error) {
        changeToUpdateBarItem()
        showError(withMessage: "\(error)")
    }
}
