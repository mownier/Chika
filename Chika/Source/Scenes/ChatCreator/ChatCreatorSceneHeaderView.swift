//
//  ChatCreatorSceneHeaderView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ChatCreatorSceneHeaderView: UIView {

    var avatar: UIImageView!
    var titleInput: UITextField!
    var messageInput: UITextField!
    
    convenience init() {
        self.init(frame: .zero)
        self.initSetup()
    }
    
    func initSetup() {
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        titleInput = UITextField()
        titleInput.autocapitalizationType = .none
        titleInput.autocorrectionType = .no
        titleInput.placeholder = "Chat title"
        
        messageInput = UITextField()
        messageInput.autocapitalizationType = .none
        messageInput.autocorrectionType = .no
        messageInput.placeholder = "Short message"
        
        addSubview(avatar)
        addSubview(titleInput)
        addSubview(messageInput)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.origin.y = spacing * 2
        rect.size.width = 64
        rect.size.height = rect.width
        let avatarRect = rect
        
        rect.origin.x = avatarRect.maxX + spacing
        rect.size.width = bounds.width - rect.minX - spacing * 2
        rect.size.height = titleInput.sizeThatFits(rect.size).height + spacing
        var titleInputRect = rect
        
        rect.size.height = messageInput.sizeThatFits(rect.size).height + spacing
        var messageInputRect = rect
        
        avatar.frame = avatarRect
        avatar.layer.cornerRadius = avatarRect.width / 2
        
        titleInputRect.origin.y = (avatarRect.maxY + avatarRect.minY - titleInputRect.height - messageInputRect.height)  / 2
        titleInput.frame = titleInputRect
        
        messageInputRect.origin.y = titleInputRect.maxY
        messageInput.frame = messageInputRect
    }
}
