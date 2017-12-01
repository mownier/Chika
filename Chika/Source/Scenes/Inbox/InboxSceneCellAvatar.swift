//
//  InboxSceneCellAvatar.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/1/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class InboxSceneCellAvatar: UIView {
    
    enum Style: UInt {
        
        case groupOf2
        case groupOf3
        case groupOf4
        case groupOf5
        case groupOfMany
        
        init(count: UInt) {
            switch count {
            case 0, 1, 2:
                self = .groupOf2
            
            case 3:
                self = .groupOf3
            
            case 4:
                self = .groupOf4
            
            case 5:
                self = .groupOf5
            
            default:
                self = .groupOfMany
            }
        }
        
        var avatarCount: UInt {
            switch self {
            case .groupOf2: return 1
            case .groupOf3: return 2
            case .groupOf4: return 3
            case .groupOf5, .groupOfMany: return 4
            }
        }
    }
    
    var avatars: [UIImageView]
    var style: Style = .groupOf2 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    init() {
        self.avatars = []
        super.init(frame: .zero)
        initSetup()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initSetup() {
        for _ in 0..<4 {
            let avatar = UIImageView()
            avatar.layer.masksToBounds = true
            avatar.backgroundColor = .gray
            avatars.append(avatar)
            addSubview(avatar)
        }
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        switch style {
        case .groupOf2:
            rect.size = bounds.size
            for (index, avatar) in avatars.enumerated() {
                guard index < style.avatarCount else {
                    avatar.frame = .zero
                    continue
                }
                
                avatar.frame = rect
                avatar.layer.cornerRadius = rect.width / 2
            }
        
        case .groupOf3:
            rect.size.width = min(bounds.height / 2, bounds.width / 2)
            rect.size.height = rect.width
            rect.origin.y = (bounds.height - rect.height) / 2
            for (index, avatar) in avatars.enumerated() {
                guard index < style.avatarCount else {
                    avatar.frame = .zero
                    continue
                }
                
                rect.origin.x = CGFloat(index) * rect.width
                avatar.frame = rect
                avatar.layer.cornerRadius = rect.width / 2
            }
            
        case .groupOf4:
            rect.size.width = min(bounds.height / 2, bounds.width / 2)
            rect.size.height = rect.width
            for (index, avatar) in avatars.enumerated() {
                guard index < style.avatarCount else {
                    avatar.frame = .zero
                    continue
                }
                
                if index == 2 {
                    rect.origin.y = rect.maxY
                    rect.origin.x = (bounds.width - rect.width) / 2
                    
                } else {
                    rect.origin.x = CGFloat(index) * rect.width
                }
                
                avatar.frame = rect
                avatar.layer.cornerRadius = rect.width / 2
            }
        
        case .groupOf5, .groupOfMany:
            rect.size.width = min(bounds.height / 2, bounds.width / 2)
            rect.size.height = rect.width
            var row: UInt = 0
            var col: UInt = 0
            for (index, avatar) in avatars.enumerated() {
                guard index < style.avatarCount else {
                    avatar.frame = .zero
                    continue
                }
                
                rect.origin.y = CGFloat(row) * rect.height
                rect.origin.x = CGFloat(col) * rect.width
                
                avatar.frame = rect
                avatar.layer.cornerRadius = rect.width / 2
                
                if index % 2 == 1 {
                    row += 1
                    col = 0
                } else {
                    col += 1
                }
            }
        }
    }
}
