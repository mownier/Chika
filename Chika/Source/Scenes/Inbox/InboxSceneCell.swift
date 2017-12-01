//
//  InboxSceneCell.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class InboxSceneCell: UITableViewCell {

    var avatarView: InboxSceneCellAvatar!
    var chatTitleLabel: UILabel!
    var chatRecentMessageLabel: UILabel!
    var timeLabel: UILabel!
    var unreadMessageCountLabel: UILabel!
    var strip: UIView!
    var onlineStatusView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "InboxSceneCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        chatTitleLabel = UILabel()
        chatTitleLabel.numberOfLines = 2
        
        chatRecentMessageLabel = UILabel()
        chatRecentMessageLabel.numberOfLines = 2
        
        avatarView = InboxSceneCellAvatar()
        
        strip = UIView()
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .right
        
        unreadMessageCountLabel = UILabel()
        unreadMessageCountLabel.textAlignment = .center
        unreadMessageCountLabel.layer.masksToBounds = true
        
        onlineStatusView = UIView()
        onlineStatusView.layer.masksToBounds = true
        
        addSubview(chatTitleLabel)
        addSubview(chatRecentMessageLabel)
        addSubview(avatarView)
        addSubview(strip)
        addSubview(timeLabel)
        addSubview(unreadMessageCountLabel)
        addSubview(onlineStatusView)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 64
        rect.size.height = rect.width
        rect.origin.x = spacing * 2
        rect.origin.y = spacing * 2
        avatarView.frame = rect
        
        rect.size.width = 120
        rect.size.height = timeLabel.sizeThatFits(rect.size).height
        rect.origin.y = avatarView.frame.origin.y
        rect.origin.x = bounds.width - rect.width - spacing * 2
        timeLabel.frame = rect
        
        rect.origin.y = timeLabel.frame.maxY + spacing
        rect.size.width = 24
        rect.size.height = unreadMessageCountLabel.sizeThatFits(rect.size).height
        rect.size = rect.height == 0 ? .zero : CGSize(width: 24, height: 24)
        rect.origin.x = bounds.width - rect.width - spacing * 2
        unreadMessageCountLabel.frame = rect
        unreadMessageCountLabel.layer.cornerRadius = rect.width / 2
        
        rect.origin.y = avatarView.frame.origin.y
        rect.origin.x = avatarView.frame.maxX + spacing
        rect.size.width = bounds.width - rect.origin.x - spacing * 2.5 - timeLabel.frame.width - (onlineStatusView.isHidden ? 0 : onlineStatusView.frame.width)
        rect.size.width = min(chatTitleLabel.sizeThatFits(rect.size).width, rect.width)
        rect.size.height = chatTitleLabel.sizeThatFits(rect.size).height
        chatTitleLabel.frame = rect

        rect.origin.y = chatTitleLabel.frame.maxY
        rect.size.width = bounds.width - rect.origin.x - spacing * 2 - unreadMessageCountLabel.frame.width
        rect.size.height = chatRecentMessageLabel.sizeThatFits(rect.size).height
        chatRecentMessageLabel.frame = rect
        
        rect.origin.x = avatarView.frame.origin.x
        rect.size.width = bounds.width - rect.origin.x
        rect.size.height = 1
        rect.origin.y = bounds.height - rect.height
        strip.frame = rect
        
        rect.size = onlineStatusView.isHidden ? .zero : CGSize(width: 10, height: 10)
        rect.origin.y = chatTitleLabel.frame.origin.y + (chatTitleLabel.font == nil ? 0 : (chatTitleLabel.font!.lineHeight - rect.height) / 2)
        rect.origin.x = chatTitleLabel.frame.maxX + spacing / 2
        onlineStatusView.frame = rect
        onlineStatusView.layer.cornerRadius = rect.width / 2
    }
}

