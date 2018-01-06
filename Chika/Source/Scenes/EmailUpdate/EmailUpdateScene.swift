//
//  EmailUpdateScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol EmailUpdateSceneInteraction: class {
    
    func didTapBack()
    func didTapUpdate()
}

protocol EmailUpdateSceneDelegate: class {
    
    func emailUpdateDidChangeEmail(_ email: String)
}

class EmailUpdateScene: UIViewController {

    weak var delegate: EmailUpdateSceneDelegate?
    
    var newEmailLabel: UILabel!
    var newEmailInput: UITextField!
    var oldEmailLabel: UILabel!
    var oldEmailInput: UITextField!
    var currPassLabel: UILabel!
    var currPassInput: UITextField!
    
    var toast: UILabel!
    
    var theme: EmailUpdateSceneTheme
    var worker: EmailUpdateSceneWorker
    var setup: EmailUpdateSceneSetup
    var waypoint: TNCore.ExitWaypoint
    
    init(theme: EmailUpdateSceneTheme,
        worker: EmailUpdateSceneWorker,
        setup: EmailUpdateSceneSetup,
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
        let waypoint = PushWaypointSource()
        self.init(theme: theme, worker: worker, setup: setup, waypoint: waypoint)
        worker.output = self
        //waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        newEmailInput = UITextField()
        newEmailInput.font = theme.inputFont
        newEmailInput.textColor = theme.inputTextColor
        newEmailInput.autocapitalizationType = .none
        newEmailInput.autocorrectionType = .no
        newEmailInput.tintColor = theme.inputTextColor
        
        oldEmailInput = UITextField()
        oldEmailInput.font = theme.inputFont
        oldEmailInput.textColor = theme.inputTextColor
        oldEmailInput.autocapitalizationType = .none
        oldEmailInput.autocorrectionType = .no
        oldEmailInput.tintColor = theme.inputTextColor
        
        currPassInput = UITextField()
        currPassInput.font = theme.inputFont
        currPassInput.textColor = theme.inputTextColor
        currPassInput.autocapitalizationType = .none
        currPassInput.autocorrectionType = .no
        currPassInput.tintColor = theme.inputTextColor
        currPassInput.isSecureTextEntry = true
        
        newEmailLabel = UILabel()
        newEmailLabel.font = theme.labelFont
        newEmailLabel.textColor = theme.labelTextColor
        newEmailLabel.text = "New Email"
        
        oldEmailLabel = UILabel()
        oldEmailLabel.font = theme.labelFont
        oldEmailLabel.textColor = theme.labelTextColor
        oldEmailLabel.text = "Current Email"
        
        currPassLabel = UILabel()
        currPassLabel.font = theme.labelFont
        currPassLabel.textColor = theme.labelTextColor
        currPassLabel.text = "Current Password"
        
        toast = UILabel()
        toast.backgroundColor = theme.toastBGColor
        toast.textColor = theme.toastTextColor
        toast.font = theme.toastFont
        toast.textAlignment = .center
        
        view.addSubview(newEmailInput)
        view.addSubview(newEmailLabel)
        view.addSubview(oldEmailInput)
        view.addSubview(oldEmailLabel)
        view.addSubview(currPassInput)
        view.addSubview(currPassLabel)
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
        
        newEmailInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.size.width = view.bounds.width - rect.minX
        rect.size.height = 32
        rect.origin.y = spacing * 2
        newEmailLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = 36
        newEmailInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing
        rect.size.height = newEmailLabel.frame.height
        oldEmailLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = newEmailLabel.frame.height
        oldEmailInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing
        rect.size.height = newEmailLabel.frame.height
        currPassLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = newEmailLabel.frame.height
        currPassInput.frame = rect
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

extension EmailUpdateScene: EmailUpdateSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapUpdate() {
        changeToIndicatorBarItem()
        let newEmail: String = newEmailInput.text ?? ""
        let currEmail: String = oldEmailInput.text ?? ""
        let currPass: String = currPassInput.text ?? ""
        worker.changeEmail(withNew: newEmail, currentEmail: currEmail, currentPassword: currPass)
    }
}

extension EmailUpdateScene: EmailUpdateSceneWorkerOutput {

    func workerDidChangeEmail(_ email: String) {
        changeToUpdateBarItem()
        showToast(withText: "EMAIL CHANGED")
        delegate?.emailUpdateDidChangeEmail(email)
    }
    
    func workerDidChangeEmailWithError(_ error: Swift.Error) {
        changeToUpdateBarItem()
        showError(withMessage: "\(error)")
    }
}
