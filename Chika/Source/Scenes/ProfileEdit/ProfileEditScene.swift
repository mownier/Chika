//
//  ProfileEditScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ProfileEditSceneInteraction: class {
    
    func didTapBack()
    func didTapSave()
}

protocol ProfileEditSceneDelegate: class {
    
    func profileEditSceneDidEdit(withPerson: Person)
}

class ProfileEditScene: UIViewController {

    weak var delegate: ProfileEditSceneDelegate?
    
    var displayNameLabel: UILabel!
    var displayNameInput: UITextField!
    var chikaNameInput: UITextField!
    var chikaNameLabel: UILabel!
    
    var toast: UILabel!
    
    var theme: ProfileEditSceneTheme
    var data: ProfileEditSceneData
    var worker: ProfileEditSceneWorker
    var flow: ProfileEditSceneFlow
    var setup: ProfileEditSceneSetup
    var cellFactory: ProfileEditSceneCellFactory
    var waypoint: AppExitWaypoint
    
    init(person: Person,
        theme: ProfileEditSceneTheme,
        data: ProfileEditSceneData,
        worker: ProfileEditSceneWorker,
        flow: ProfileEditSceneFlow,
        setup: ProfileEditSceneSetup,
        cellFactory: ProfileEditSceneCellFactory,
        waypoint: AppExitWaypoint) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
        data.me = person
    }
    
    convenience init(person: Person) {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ProfileEditSceneCell.Factory()
        let setup = Setup()
        let waypoint = ProfileEditScene.ExitWaypoint()
        self.init(person: person, theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(person: Person())
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        displayNameInput = UITextField()
        displayNameInput.font = theme.inputFont
        displayNameInput.textColor = theme.inputTextColor
        displayNameInput.autocapitalizationType = .none
        displayNameInput.autocorrectionType = .no
        displayNameInput.tintColor = theme.inputTextColor
        
        chikaNameInput = UITextField()
        chikaNameInput.font = theme.inputFont
        chikaNameInput.textColor = theme.inputTextColor
        chikaNameInput.autocapitalizationType = .none
        chikaNameInput.autocorrectionType = .no
        chikaNameInput.tintColor = theme.inputTextColor
        
        displayNameLabel = UILabel()
        displayNameLabel.font = theme.labelFont
        displayNameLabel.textColor = theme.labelTextColor
        displayNameLabel.text = "Display Name"
        
        chikaNameLabel = UILabel()
        chikaNameLabel.font = theme.labelFont
        chikaNameLabel.textColor = theme.labelTextColor
        chikaNameLabel.text = "Chika Name"
        
        toast = UILabel()
        toast.backgroundColor = theme.toastBGColor
        toast.textColor = theme.toastTextColor
        toast.font = theme.toastFont
        toast.textAlignment = .center
        
        view.addSubview(displayNameInput)
        view.addSubview(displayNameLabel)
        view.addSubview(chikaNameInput)
        view.addSubview(chikaNameLabel)
        view.addSubview(toast)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        changeToSaveBarItem()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        displayNameInput.placeholder = data.me.displayName
        displayNameInput.text = data.me.displayName
        chikaNameInput.placeholder = data.me.name
        chikaNameInput.text = data.me.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayNameInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.size.width = view.bounds.width - rect.minX
        rect.size.height = 32
        rect.origin.y = spacing * 2
        displayNameLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = 36
        displayNameInput.frame = rect
        
        rect.origin.y = rect.maxY + spacing
        rect.size.height = displayNameLabel.frame.height
        chikaNameLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = displayNameInput.frame.height
        chikaNameInput.frame = rect
    }
    
    func changeToSaveBarItem() {
        let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.didTapSave))
        navigationItem.rightBarButtonItem = save
        
        if let font = theme.barItemFont {
            save.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
    }
    
    func changeToIndicatorBarItem() {
        let indicator = UIActivityIndicatorView()
        indicator.color = theme.indicatorColor
        indicator.startAnimating()
        let barItem = UIBarButtonItem(customView: indicator)
        navigationItem.rightBarButtonItem = barItem
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
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileEditScene: ProfileEditSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapSave() {
        changeToIndicatorBarItem()
        var person = data.me
        person.displayName = displayNameInput.text ?? ""
        person.name = chikaNameInput.text ?? ""
        worker.save(newValue: person, oldValue: data.me)
    }
}

extension ProfileEditScene: ProfileEditSceneWorkerOutput {
    
    func workerDidSaveWithNewValue(_ person: Person) {
        changeToSaveBarItem()
        showToast(withText: "UPDATED")
        data.me = person
        delegate?.profileEditSceneDidEdit(withPerson: data.me)
    }
    
    func workerDidSaveWithError(_ error: Error) {
        changeToSaveBarItem()
        chikaNameInput.text = data.me.name
        displayNameInput.text = data.me.displayName
        showError(withMessage: "\(error)")
    }
}
