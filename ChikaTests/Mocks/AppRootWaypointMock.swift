//
//  TNCore.RootWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
@testable import Chika

class TNCore.RootWaypointMock: TNCore.RootWaypoint {

    var isMakeRootCalled: Bool = false
    var isMakeRootOK: Bool = false
    
    func makeRoot(from window: UIWindow?) -> Bool {
        isMakeRootCalled = true
        return isMakeRootOK
    }
}
