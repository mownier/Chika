//
//  InboxSceneSetupMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
@testable import Chika

class InboxSceneSetupMock: InboxSceneSetup {

    var isFormatOK: Bool = false
    var cellHeight: CGFloat = 0
    
    func format(cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> Bool {
        return isFormatOK
    }
    
    func height(for cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> CGFloat {
        return cellHeight
    }
}
