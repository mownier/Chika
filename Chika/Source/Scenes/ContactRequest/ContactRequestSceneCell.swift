//
//  ContactRequestSceneCell.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactRequestSceneCellInteraction: class {
    
}

protocol ContactRequestSceneCellAction: class {
    
}

class ContactRequestSceneCell: UITableViewCell {

    weak var action: ContactRequestSceneCellAction?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ContactRequestSceneCell")
    }
    
    func initSetup() {
        
    }
}

extension ContactRequestSceneCell: ContactRequestSceneCellInteraction {
    
}
