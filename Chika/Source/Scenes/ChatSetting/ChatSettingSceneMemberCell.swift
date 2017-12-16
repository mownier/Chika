//
//  ChatSettingSceneMemberCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ChatSettingSceneMemberCellInteraction: class {
    
}

protocol ChatSettingSceneMemberCellAction: class {
    
}

class ChatSettingSceneMemberCell: UITableViewCell {

    weak var action: ChatSettingSceneMemberCellAction?
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var onlineStatusView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ChatSettingSceneMemberCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        
        onlineStatusView = UIView()
        onlineStatusView.layer.masksToBounds = true
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(onlineStatusView)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 40
        rect.size.height = rect.width
        rect.origin.x = spacing * 2
        rect.origin.y = spacing
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
        
        rect.size = CGSize(width: 16, height: 16)
        rect.origin.y = (avatar.frame.midY - rect.height + spacing) / 2
        rect.origin.x = (avatar.frame.midX - rect.width + spacing) / 2
        onlineStatusView.frame = rect
        onlineStatusView.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = avatar.frame.maxX + spacing
        rect.origin.y = avatar.frame.midY - nameLabel.font.lineHeight / 2
        rect.size.width = bounds.width - rect.origin.x - spacing * 2
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        nameLabel.frame = rect
    }
}

extension ChatSettingSceneMemberCell: ChatSettingSceneMemberCellInteraction {
    
}
