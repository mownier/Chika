//
//  ViewMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ViewMock: UIView {

    var win: UIWindow
    
    override var window: UIWindow? {
        return win
    }
    
    init(win: UIWindow) {
        self.win = win
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
