//
//  ConvoSceneCell.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ConvoSceneCell: UITableViewCell {

    enum ReuseID: String {
    
        case left = "CellForLeft"
        case right = "CellForRight"
    }
    
    var avatarImageView: UIImageView!
    var contentLabel: UILabel!
    var contentBGView: UIView!
    var authorLabel: UILabel!
    var timeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(reuseID: ReuseID.left)
    }
    
    convenience init(reuseID: ReuseID) {
        self.init(style: .default, reuseIdentifier: reuseID.rawValue)
    }
    
    func initSetup() {
        selectionStyle = .none
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        
        contentBGView = UIView()
        contentBGView.layer.cornerRadius = 4
        contentBGView.layer.masksToBounds = true
        
        avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .gray
        avatarImageView.layer.masksToBounds = true
        
        authorLabel = UILabel()
        authorLabel.numberOfLines = 0
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 0
        timeLabel.textAlignment = reuseIdentifier == ReuseID.right.rawValue ? .right : .left
        
        addSubview(contentBGView)
        addSubview(contentLabel)
        addSubview(avatarImageView)
        addSubview(authorLabel)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        guard let reuseID = reuseIdentifier else {
            return
        }
        
        let spacing: CGFloat = 8
        var rect = CGRect.zero
        
        switch reuseID {
        case ReuseID.left.rawValue:
            let avatarWidth: CGFloat = 32
            
            rect.origin.y = spacing
            rect.origin.x = spacing
            rect.size.width = avatarWidth
            rect.size.height = rect.width
            avatarImageView.frame = rect
            avatarImageView.layer.cornerRadius = rect.width / 2
            
            rect.origin.x = rect.maxX + spacing
            rect.size.width = (bounds.width - rect.origin.x - spacing) * 0.8
            if authorLabel.isHidden {
                rect.origin.y = -spacing
                rect.size.height = 0
            } else {
                rect.size.height = authorLabel.sizeThatFits(rect.size).height
            }
            authorLabel.frame = rect
            
            rect.origin.y = rect.maxY + spacing * 2
            rect.size.width -= (spacing * 2)
            rect.size.height = contentLabel.sizeThatFits(rect.size).height
            contentLabel.frame = rect
            rect.size.width = min(rect.width, contentLabel.intrinsicContentSize.width)
            rect.origin.x += spacing
            contentLabel.frame = rect
            
            rect.size.width += (spacing * 2)
            rect.size.height += (spacing * 2)
            rect.origin.y -= spacing
            rect.origin.x -= spacing
            contentBGView.frame = rect
            
            rect.origin.y = rect.maxY
            
            if timeLabel.isHidden {
                rect.size = .zero
                
            } else {
                rect.size.width = bounds.width - rect.origin.x - avatarImageView.frame.origin.x
                rect.size.height = timeLabel.sizeThatFits(rect.size).height
                rect.origin.y += spacing
            }
            
            timeLabel.frame = rect
            
        case ReuseID.right.rawValue:
            rect.size.width = bounds.width * 0.8 - spacing * 2
            rect.size.height = contentLabel.sizeThatFits(rect.size).height
            rect.origin.y = spacing * 2
            contentLabel.frame = rect
            rect.size.width = min(rect.width, contentLabel.intrinsicContentSize.width)
            rect.origin.x = bounds.width - rect.width - spacing * 2
            contentLabel.frame = rect
            
            rect.size.width += (spacing * 2)
            rect.size.height = rect.maxY
            rect.origin.y = spacing
            rect.origin.x = bounds.width - rect.width - spacing
            contentBGView.frame = rect
         
            rect.origin.y = rect.maxY
            
            if timeLabel.isHidden {
                rect.size = .zero
                
            } else {
                rect.size.width = bounds.width * 0.8 - spacing * 2
                rect.size.height = timeLabel.sizeThatFits(rect.size).height
                rect.origin.y += spacing
                rect.origin.x = bounds.width - rect.width - spacing
            }
            
            timeLabel.frame = rect
            
        default:
            break
        }
    }
}
