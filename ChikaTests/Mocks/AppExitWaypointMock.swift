//
//  AppExitWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class AppExitWaypointMock: AppExitWaypoint {

    var isExitCalled: Bool
    
    init() {
        isExitCalled = false
    }
    
    func exit() -> Bool {
        isExitCalled = true
        return true
    }
}
