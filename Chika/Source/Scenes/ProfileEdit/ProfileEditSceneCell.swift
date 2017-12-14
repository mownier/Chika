//
//  ProfileEditSceneCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ProfileEditSceneCellInteraction: class {
    
}

protocol ProfileEditSceneCellAction: class {
    
}

class ProfileEditSceneCell: UITableViewCell {

    weak var action: ProfileEditSceneCellAction?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ProfileEditSceneCell")
    }
    
    func initSetup() {
        
    }
}

extension ProfileEditSceneCell: ProfileEditSceneCellInteraction {
    
}
