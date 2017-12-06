
//
//  ContactsSceneSearchResultEmptyView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ContactsSceneSearchResultEmptyView: UIView {

    var titleLabel: UILabel!
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }

    func initSetup() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = bounds.width
        rect.size.height = 58
        titleLabel.frame = rect
    }
}
