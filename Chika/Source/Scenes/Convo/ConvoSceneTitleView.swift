//
//  ConvoSceneTitleView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ConvoSceneTitleView: UIView {

    var nameLabel: UILabel!
    var activeLabel: UILabel!
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        
        activeLabel = UILabel()
        activeLabel.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(activeLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = bounds.width
        rect.size.height = nameLabel.sizeThatFits(rect.size).height
        var nameRect = rect
        
        rect.size.height = activeLabel.sizeThatFits(rect.size).height
        var activeRect = rect
        
        nameRect.origin.y = (bounds.height - (nameRect.height + activeRect.height)) / 2
        nameLabel.frame = nameRect
        
        activeRect.origin.y = nameRect.maxY
        activeLabel.frame = activeRect
    }
}
