//
//  ConvoSceneTypingView.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/29/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ConvoSceneTypingView: UITableViewCell {

    var infoLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(style: .default, reuseIdentifier: "ConvoSceneTypingView")
        initSetup()
    }
    
    func initSetup() {
        selectionStyle = .none
        infoLabel = UILabel()
        addSubview(infoLabel)
    }
    
    override func layoutSubviews() {
        infoLabel.frame = bounds.insetBy(dx: 8, dy: 8)
    }
}
