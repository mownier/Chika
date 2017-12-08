//
//  ProfileSceneHeaderView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ProfileSceneHeaderView: UIView {

    var avatar: UIImageView!
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }

    func initSetup() {
        avatar = UIImageView()
        avatar.layer.masksToBounds = true
        
        addSubview(avatar)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = 120
        rect.size.height = rect.width
        rect.origin.y = (bounds.height - rect.height) / 2
        rect.origin.x = (bounds.width - rect.width) / 2
        avatar.frame = rect
        avatar.layer.cornerRadius = rect.width / 2
    }
}
