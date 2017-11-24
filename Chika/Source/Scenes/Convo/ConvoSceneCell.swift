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
    
    var contentLabel: UILabel!
    var contentBGView: UIView!
    
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
        
        addSubview(contentBGView)
        addSubview(contentLabel)
    }
    
    override func layoutSubviews() {
        guard let reuseID = reuseIdentifier else {
            return
        }
        
        let spacing: CGFloat = 8
        var rect = CGRect.zero
        rect.origin.y = spacing * 4
        
        switch reuseID {
        case ReuseID.left.rawValue:
            contentBGView.backgroundColor = .blue
            contentLabel.textColor = .white
            
            rect.size.width = bounds.width * 0.8 - spacing * 4
            rect.origin.x = spacing * 4
            rect.size.height = contentLabel.sizeThatFits(rect.size).height
            contentLabel.frame = rect
            if contentLabel.intrinsicContentSize.width < rect.width {
                rect.size.width = contentLabel.intrinsicContentSize.width
                contentLabel.frame = rect
            }
            
            rect.origin.y -= (spacing * 2)
            rect.origin.x -= (spacing * 2)
            rect.size.height += (spacing * 4)
            rect.size.width += (spacing * 4)
            contentBGView.frame = rect
            
        case ReuseID.right.rawValue:
            contentBGView.backgroundColor = .orange
            
            rect.size.width = bounds.width * 0.8 - spacing * 4
            rect.origin.x = bounds.width - rect.width - spacing * 4
            rect.size.height = contentLabel.sizeThatFits(rect.size).height
            contentLabel.frame = rect
            if contentLabel.intrinsicContentSize.width < rect.width {
                rect.size.width = contentLabel.intrinsicContentSize.width
                rect.origin.x = bounds.width - contentLabel.intrinsicContentSize.width - spacing * 4
                contentLabel.frame = rect
            }
            
            rect.origin.y -= (spacing * 2)
            rect.origin.x -= (spacing * 2)
            rect.size.height += (spacing * 4)
            rect.size.width += (spacing * 4)
            contentBGView.frame = rect
            
        default:
            break
        }
    }
}
