//
//  ContactChatSettingScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol ContactChatSettingSceneInteraction: class {
    
    func didTapBack()
    func didTapEdit()
    func didTapEditCancel()
    func didTapEditOK()
    func didTapCreate()
}

protocol ContactChatSettingSceneDelegate: class {
    
    func contactChatSettingSceneDidUpdateTitle(_ title: String)
    func contactChatSettingSceneDidCreatChat(_ chat: Chat)
}

class ContactChatSettingScene: UIViewController {

    var avatar: UIImageView!
    var titleEditCancelButton: UIButton!
    var titleEditButton: UIButton!
    var titleLabel: UILabel!
    var titleEditOKButton: UIButton!
    var titleInput: UITextField!
    var createButton: UIButton!
    
    weak var delegate: ContactChatSettingSceneDelegate?
    
    var theme: ContactChatSettingSceneTheme
    var data: ContactChatSettingSceneData
    var worker: ContactChatSettingSceneWorker
    var flow: ContactChatSettingSceneFlow
    var setup: ContactChatSettingSceneSetup
    var waypoint: TNCore.ExitWaypoint
    
    var isEditingTitle: Bool = false {
        didSet {
            let _ = isEditingTitle ? titleInput.becomeFirstResponder() : titleInput.resignFirstResponder()
            titleInput.isHidden = !isEditingTitle
            titleEditCancelButton.isHidden = !isEditingTitle
            titleEditOKButton.isHidden = !isEditingTitle
            titleLabel.isHidden = isEditingTitle
            titleEditButton.isHidden = isEditingTitle
        }
    }
    
    init(theme: ContactChatSettingSceneTheme,
        data: ContactChatSettingSceneData,
        worker: ContactChatSettingSceneWorker,
        flow: ContactChatSettingSceneFlow,
        setup: ContactChatSettingSceneSetup,
        waypoint: TNCore.ExitWaypoint) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(contact: Contact) {
        let theme = Theme()
        let data = Data(contact: contact)
        let worker = Worker()
        let flow = Flow()
        let setup = Setup()
        let waypoint = ContactChatSettingScene.ExitWaypoint()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(contact: Contact())
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        avatar.backgroundColor = theme.avatarBGColor
        
        titleInput = UITextField()
        titleInput.autocorrectionType = .no
        titleInput.autocapitalizationType = .none
        titleInput.placeholder = "Chat Title"
        titleInput.textAlignment = .center
        titleInput.textColor = theme.titleTextColor
        titleInput.font = theme.titleFont
        titleInput.delegate = self
        
        titleEditButton = UIButton()
        titleEditButton.setImage(#imageLiteral(resourceName: "pencil_button"), for: .normal)
        titleEditButton.tintColor = theme.titleTextColor
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = theme.titleTextColor
        titleLabel.font = theme.titleFont
        
        titleEditCancelButton = UIButton()
        titleEditCancelButton.setImage(#imageLiteral(resourceName: "x_icon"), for: .normal)
        titleEditCancelButton.tintColor = theme.destructiveTextColor
        
        titleEditOKButton = UIButton()
        titleEditOKButton.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
        titleEditOKButton.tintColor = theme.positiveTextColor
        
        createButton = UIButton()
        createButton.setTitleColor(theme.createTitleTextColor, for: .normal)
        createButton.backgroundColor = theme.createBGColor
        createButton.titleLabel?.font = theme.createTitleFont
        createButton.titleLabel?.numberOfLines = 0
        createButton.titleLabel?.textAlignment = .center
        createButton.layer.masksToBounds = true
        
        isEditingTitle = false
        
        createButton.addTarget(self, action: #selector(self.didTapCreate), for: .touchUpInside)
        titleEditButton.addTarget(self, action: #selector(self.didTapEdit), for: .touchUpInside)
        titleEditOKButton.addTarget(self, action: #selector(self.didTapEditOK), for: .touchUpInside)
        titleEditCancelButton.addTarget(self, action: #selector(self.didTapEditCancel), for: .touchUpInside)
        
        view.addSubview(avatar)
        view.addSubview(titleInput)
        view.addSubview(titleEditButton)
        view.addSubview(titleLabel)
        view.addSubview(titleEditCancelButton)
        view.addSubview(titleEditOKButton)
        view.addSubview(createButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        titleLabel.text = data.item.contact.chat.title
        
        createButton.setTitle("Create Group Chat", for: .normal)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        let buttonWidth: CGFloat = 32
        
        var rect = CGRect.zero
        
        rect.size.width = 120
        rect.size.height = rect.width
        rect.origin.x = (view.bounds.width - rect.width) / 2
        var avatarRect = rect
        
        rect.size.width = view.bounds.width - spacing * 4 - buttonWidth
        rect.size.height = titleLabel.sizeThatFits(rect.size).height
        titleLabel.frame = rect
        titleLabel.sizeToFit()
        rect.size.width = min(titleLabel.bounds.width, rect.width)
        rect.origin.x = (view.bounds.width - rect.width) / 2
        var titleLabelRect = rect
        
        rect.origin.x = titleLabelRect.maxX
        rect.size.width = buttonWidth
        rect.size.height = titleLabelRect.height
        var titleEditButtonRect = rect
        
        rect.origin.x = buttonWidth + spacing * 2
        rect.size.width = view.bounds.width - rect.minX * 2
        rect.size.height = titleLabelRect.height
        var titleInputRect = rect
        
        rect.origin.x = spacing * 2
        rect.size.width = titleEditButtonRect.size.width
        rect.size.height = titleInputRect.height
        var titleEditCancelButtonRect = rect
        
        rect.origin.x = view.bounds.width - spacing * 2 - rect.width
        var titleEditOKButtonRect = rect
        
        rect.size.width = 200
        rect.size.height = createButton.sizeThatFits(rect.size).height + spacing
        createButton.frame = rect
        createButton.sizeToFit()
        rect.size.width = min(rect.width + spacing * 4, createButton.bounds.width + spacing * 4)
        rect.origin.x = (view.bounds.width - rect.width) / 2
        var createButtonRect = rect
        
        avatarRect.origin.y = spacing * 4
        avatar.frame = avatarRect
        avatar.layer.cornerRadius = avatarRect.width / 2
        
        titleLabelRect.origin.y = avatarRect.maxY + spacing
        titleLabel.frame = titleLabelRect
        
        titleEditButtonRect.origin.y = titleLabelRect.minY
        titleEditButton.frame = titleEditButtonRect
        
        titleInputRect.origin.y = titleLabelRect.minY
        titleInput.frame = titleInputRect
        
        titleEditOKButtonRect.origin.y = titleInputRect.minY
        titleEditOKButton.frame = titleEditOKButtonRect
        
        titleEditCancelButtonRect.origin.y = titleInputRect.minY
        titleEditCancelButton.frame = titleEditCancelButtonRect
        
        createButtonRect.origin.y = titleLabelRect.maxY + spacing
        createButton.frame = createButtonRect
        createButton.layer.cornerRadius = min(createButtonRect.height, createButtonRect.width) / 2
    }
}

extension ContactChatSettingScene: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditingTitle = false
    }
}

extension ContactChatSettingScene: ContactChatSettingSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapEdit() {
        isEditingTitle = true
        titleInput.text = data.item.contact.chat.title
    }
    
    func didTapEditOK() {
        isEditingTitle = false
        guard let title = titleInput.text, !title.isEmpty else {
            return
        }
        
        titleInput.text = ""
        titleLabel.text = title
        view.setNeedsLayout()
        view.layoutIfNeeded()
        worker.updateTitle(of: data.item.contact.chat.id, title: title)
    }
    
    func didTapEditCancel() {
        isEditingTitle = false
    }
    
    func didTapCreate() {
        let _ = flow.goToChatCreator(withDefaultParticipants: data.item.contact.chat.participants, minimumOtherParticipantLimit: 2, delegate: self)
    }
}

extension ContactChatSettingScene: ContactChatSettingSceneWorkerOutput {

    func workerDidUpdateTitle(_ title: String) {
        data.updateTitle(title)
        titleLabel.text = title
        view.setNeedsLayout()
        view.layoutIfNeeded()
        delegate?.contactChatSettingSceneDidUpdateTitle(title)
    }
    
    func workerDidUpdateTitleWithError(_ error: Swift.Error) {
        titleLabel.text = data.item.contact.chat.title
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension ContactChatSettingScene: ChatCreatorSceneDelegate {
    
    func chatCreatorSceneDidCreateChat(_ chat: Chat) {
        delegate?.contactChatSettingSceneDidCreatChat(chat)
        let _ = waypoint.exit()
    }
}
