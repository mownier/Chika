//
//  AppEntryWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
@testable import Chika

class AppEntryWaypointMock: AppEntryWaypoint {

    var isEnterCalled: Bool
    var isEnterOK: Bool
    
    init() {
        isEnterCalled = false
        isEnterOK = false
    }
    
    func enter(from parent: UIViewController) -> Bool {
        isEnterCalled = true
        return isEnterOK
    }
}
