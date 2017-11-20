//
//  InboxSceneCell.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class InboxSceneCell: UITableViewCell {

    var chatTitleLabel: UILabel!
    var chatRecentMessageLabel: UILabel!
    
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
        chatTitleLabel = UILabel()
        chatTitleLabel.numberOfLines = 2
        
        chatRecentMessageLabel = UILabel()
        chatRecentMessageLabel.numberOfLines = 2
        
        addSubview(chatTitleLabel)
        addSubview(chatRecentMessageLabel)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var (rect, rem) = bounds.divided(atDistance: spacing, from: .minYEdge)
        rect = rem.insetBy(dx: 10, dy: 0)
        rect.size.height = chatTitleLabel.sizeThatFits(rect.size).height
        chatTitleLabel.frame = rect
        
        (rect, rem) = bounds.divided(atDistance: rect.maxY, from: .minYEdge)
        rect = rem.insetBy(dx: 10, dy: 0)
        rect.size.height = chatTitleLabel.sizeThatFits(rect.size).height
        chatRecentMessageLabel.frame = rect
    }
}

