//
//  ContactsSceneCell.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactsSceneCellInteraction: class {
    
    func didTapAdd()
}

protocol ContactsSceneCellAction: class {
    
    func contactsSceneCellWillAddContact(_ cell: UITableViewCell)
}

class ContactsSceneCell: UITableViewCell {

    weak var action: ContactsSceneCellAction?
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var onlineStatusView: UIView!
    var strip: UIView!
    var addButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ContactsSceneCell")
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        
        onlineStatusView = UIView()
        onlineStatusView.layer.masksToBounds = true
        
        strip = UIView()
        
        addButton = UIButton()
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 3
        addButton.setTitle("Add Contact", for: .normal)
        addButton.addTarget(self, action: #selector(self.didTapAdd), for: .touchUpInside)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(onlineStatusView)
        addSubview(strip)
        addSubview(addButton)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size.width = 100
        rect.size.height = 36
        rect.origin.y = (bounds.height - rect.height) / 2
        rect.origin.x = bounds.width - rect.width - spacing
        addButton.frame = rect
        
        rect.size.width = 40
        rect.size.height = rect.width
        rect.origin.x = spacing
        rect.origin.y = (bounds.height - rect.height) / 2
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
        
        rect.size = onlineStatusView.isHidden ? .zero : CGSize(width: 10, height: 10)
        rect.origin.y = (bounds.height - rect.height) / 2
        rect.origin.x = bounds.width - rect.width - spacing
        onlineStatusView.frame = rect
        onlineStatusView.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = avatar.frame.maxX + spacing
        rect.size.width = bounds.width - rect.origin.x - spacing * 2 - (addButton.isHidden ? onlineStatusView.frame.width : addButton.frame.width)
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        rect.origin.y = (bounds.height - rect.height) / 2
        nameLabel.frame = rect
        
        rect.size.width = bounds.width
        rect.size.height = 1
        rect.origin.x = 0
        rect.origin.y = bounds.height - rect.height
        strip.frame = rect
    }
}

extension ContactsSceneCell: ContactsSceneCellInteraction {
    
    func didTapAdd() {
        action?.contactsSceneCellWillAddContact(self)
    }
}
