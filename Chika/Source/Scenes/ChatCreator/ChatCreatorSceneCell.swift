//
//  ChatCreatorSceneCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ChatCreatorSceneCellInteraction: class {
    
    func didTapSelect()
}

protocol ChatCreatorSceneCellAction: class {
    
    func chatCreatorSceneCellWillToggleSelection(_ cell: ChatCreatorSceneCell)
}

class ChatCreatorSceneCell: UITableViewCell {

    weak var action: ChatCreatorSceneCellAction?
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var selectButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ChatCreatorSceneCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        
        selectButton = UIButton()
        selectButton.layer.masksToBounds = true
        selectButton.addTarget(self, action: #selector(self.didTapSelect), for: .touchUpInside)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(selectButton)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 40
        rect.size.height = 40
        rect.origin.y = spacing
        rect.origin.x = bounds.width - rect.width - spacing * 2
        selectButton.frame = rect
        selectButton.layer.cornerRadius = rect.width / 2
        
        rect.size.width = 40
        rect.size.height = rect.width
        rect.origin.x = spacing * 2
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = avatar.frame.maxX + spacing
        rect.origin.y = avatar.frame.midY - nameLabel.font.lineHeight / 2
        rect.size.width = bounds.width - rect.origin.x - selectButton.frame.width - spacing * 3
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        nameLabel.frame = rect
    }
}

extension ChatCreatorSceneCell: ChatCreatorSceneCellInteraction {
    
    func didTapSelect() {
        action?.chatCreatorSceneCellWillToggleSelection(self)
    }
}
