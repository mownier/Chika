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
    
    init() {
        isEnterCalled = false
    }
    
    func enter(from parent: UIViewController) -> Bool {
        isEnterCalled = true
        return true
    }
}
