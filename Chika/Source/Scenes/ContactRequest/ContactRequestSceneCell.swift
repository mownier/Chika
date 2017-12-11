//
//  ContactRequestSceneCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactRequestSceneCellInteraction: class {
    
}

protocol ContactRequestSceneCellAction: class {
    
}

class ContactRequestSceneCell: UITableViewCell {

    weak var action: ContactRequestSceneCellAction?
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var messageLabel: UILabel!
    var statusLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ContactRequestSceneCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        
        statusLabel = UILabel()
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 4
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(statusLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 40
        rect.size.height = rect.width
        rect.origin.x = spacing * 2
        rect.origin.y = spacing
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = avatar.frame.maxX + spacing
        rect.origin.y = avatar.frame.midY - nameLabel.font.lineHeight / 2
        rect.size.width = contentView.bounds.width - rect.origin.x
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        nameLabel.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = messageLabel.sizeThatFits(rect.size).height
        messageLabel.frame = rect
        
        rect.size.width = 100
        rect.size.height = statusLabel.sizeThatFits(rect.size).height + spacing
        rect.origin.y = messageLabel.frame.maxY
        statusLabel.frame = rect
    }
}

extension ContactRequestSceneCell: ContactRequestSceneCellInteraction {
    
}
