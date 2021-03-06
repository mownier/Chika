//
//  PeopleSearchSceneCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol PeopleSearchSceneCellInteraction: class {
    
    func didTapAdd()
}

protocol PeopleSearchSceneCellAction: class {
    
    func peopleSearchSceneCellWillAddContact(_ cell: UITableViewCell)
}

class PeopleSearchSceneCell: UITableViewCell {

    weak var action: PeopleSearchSceneCellAction?
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var onlineStatusView: UIView!
    var addButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "PeopleSearchSceneCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        
        onlineStatusView = UIView()
        onlineStatusView.layer.masksToBounds = true
        
        addButton = UIButton()
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 3
        addButton.setTitle("Add Contact", for: .normal)
        addButton.addTarget(self, action: #selector(self.didTapAdd), for: .touchUpInside)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(onlineStatusView)
        addSubview(addButton)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 108
        rect.size.height = 40
        rect.origin.y = spacing
        rect.origin.x = bounds.width - rect.width - spacing * 2
        addButton.frame = rect
        
        rect.size.width = 40
        rect.size.height = rect.width
        rect.origin.x = spacing * 2
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
        
        rect.size = CGSize(width: 16, height: 16)
        rect.origin.y = (avatar.frame.midY - rect.height + spacing) / 2
        rect.origin.x = (avatar.frame.midX - rect.width + spacing) / 2
        onlineStatusView.frame = rect
        onlineStatusView.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = avatar.frame.maxX + spacing
        rect.origin.y = avatar.frame.midY - nameLabel.font.lineHeight / 2
        rect.size.width = bounds.width - rect.origin.x - (addButton.isHidden ? spacing * 2 : addButton.frame.width + spacing * 3)
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        nameLabel.frame = rect
    }
}

extension PeopleSearchSceneCell: PeopleSearchSceneCellInteraction {
    
    func didTapAdd() {
        action?.peopleSearchSceneCellWillAddContact(self)
    }
}
