//
//  ChatSettingSceneHeaderView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ChatSettingSceneHeaderView: UIView {

    var avatar: UIImageView!
    var titleInput: UITextField!
    var creatorLabel: UILabel!
    
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
        
        addSubview(avatar)
        addSubview(titleInput)
        addSubview(creatorLabel)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 120
        rect.size.height = rect.width
        rect.origin.x = (bounds.width - rect.width) / 2
        var avatarRect = rect
        
        rect.origin.x = spacing * 2
        rect.size.width = bounds.width - rect.origin.x * 2
        rect.size.height = titleInput.sizeThatFits(rect.size).height
        var titleInputRect = rect
        
        rect.size.height = creatorLabel.sizeThatFits(rect.size).height
        var creatorLabelRect = rect
        
        avatarRect.origin.y = (bounds.height - (avatarRect.height + titleInputRect.height + creatorLabelRect.height + spacing)) / 2
        avatar.frame = avatarRect
        avatar.layer.cornerRadius = avatarRect.width / 2
        
        titleInputRect.origin.y = avatarRect.maxY + spacing
        titleInput.frame = titleInputRect
        
        creatorLabelRect.origin.y = titleInputRect.maxY
        creatorLabel.frame = creatorLabelRect
    }

}
