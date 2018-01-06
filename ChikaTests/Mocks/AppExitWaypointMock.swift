//
//  TNCore.ExitWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika
import TNCore

class AppExitWaypointMock: TNCore.ExitWaypoint {

    var isExitCalled: Bool
    var isExitOK: Bool
    
    init() {
        isExitCalled = false
        isExitOK = false
    }
    
    func exit() -> Bool {
        isExitCalled = true
        return isExitOK
    }
}
