//
//  ChatSettingSceneHeaderView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ChatSettingSceneHeaderView: UIView {

    var titleEditCancelButton: UIButton!
    var titleEditButton: UIButton!
    var titleLabel: UILabel!
    var titleEditOKButton: UIButton!
    
    var avatar: UIImageView!
    var titleInput: UITextField!
    var creatorLabel: UILabel!
    
    var isEditing: Bool = false {
        didSet {
            let _ = isEditing ? titleInput.becomeFirstResponder() : titleInput.resignFirstResponder()
            titleInput.isHidden = !isEditing
            titleEditCancelButton.isHidden = !isEditing
            titleEditOKButton.isHidden = !isEditing
            titleLabel.isHidden = isEditing
            titleEditButton.isHidden = isEditing
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        titleInput = UITextField()
        titleInput.autocorrectionType = .no
        titleInput.autocapitalizationType = .none
        titleInput.placeholder = "Chat Title"
        titleInput.textAlignment = .center
        
        creatorLabel = UILabel()
        creatorLabel.numberOfLines = 2
        creatorLabel.textAlignment = .center
        
        titleEditButton = UIButton()
        titleEditButton.setImage(#imageLiteral(resourceName: "pencil_button"), for: .normal)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        titleEditCancelButton = UIButton()
        titleEditCancelButton.setImage(#imageLiteral(resourceName: "x_icon"), for: .normal)
        
        titleEditOKButton = UIButton()
        titleEditOKButton.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
        
        addSubview(avatar)
        addSubview(titleInput)
        addSubview(creatorLabel)
        addSubview(titleEditButton)
        addSubview(titleLabel)
        addSubview(titleEditCancelButton)
        addSubview(titleEditOKButton)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        let buttonWidth: CGFloat = 32
        
        var rect = CGRect.zero
        
        rect.size.width = 120
        rect.size.height = rect.width
        rect.origin.x = (bounds.width - rect.width) / 2
        var avatarRect = rect
        
        rect.size.width = bounds.width - spacing * 4 - buttonWidth
        rect.size.height = titleLabel.sizeThatFits(rect.size).height
        titleLabel.frame = rect
        titleLabel.sizeToFit()
        rect.size.width = min(titleLabel.bounds.width, rect.width)
        rect.origin.x = (bounds.width - rect.width) / 2
        var titleLabelRect = rect
        
        rect.origin.x = spacing * 2
        rect.size.width = bounds.width - rect.minX * 2
        rect.size.height = creatorLabel.sizeThatFits(rect.size).height
        var creatorLabelRect = rect
        
        rect.origin.x = titleLabelRect.maxX
        rect.size.width = buttonWidth
        rect.size.height = titleLabelRect.height
        var titleEditButtonRect = rect
        
        rect.origin.x = buttonWidth + spacing * 2
        rect.size.width = bounds.width - rect.minX * 2
        rect.size.height = titleLabelRect.height
        var titleInputRect = rect
        
        rect.origin.x = spacing * 2
        rect.size.width = titleEditButtonRect.size.width
        rect.size.height = titleInputRect.height
        var titleEditCancelButtonRect = rect
        
        rect.origin.x = bounds.width - spacing * 2 - rect.width
        var titleEditOKButtonRect = rect
        
        avatarRect.origin.y = (bounds.height - (avatarRect.height + titleLabelRect.height + creatorLabelRect.height + spacing)) / 2
        avatar.frame = avatarRect
        avatar.layer.cornerRadius = avatarRect.width / 2
        
        titleLabelRect.origin.y = avatarRect.maxY + spacing
        titleLabel.frame = titleLabelRect
        
        creatorLabelRect.origin.y = titleLabelRect.maxY
        creatorLabel.frame = creatorLabelRect
        
        titleEditButtonRect.origin.y = titleLabelRect.minY
        titleEditButton.frame = titleEditButtonRect
        
        titleInputRect.origin.y = titleLabelRect.minY
        titleInput.frame = titleInputRect
        
        titleEditOKButtonRect.origin.y = titleInputRect.minY
        titleEditOKButton.frame = titleEditOKButtonRect
        
        titleEditCancelButtonRect.origin.y = titleInputRect.minY
        titleEditCancelButton.frame = titleEditCancelButtonRect
    }
}
