//
//  ExitWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class ExitWaypointMock: AppExitWaypoint {

    var isExitOK: Bool = false
    
    func exit() -> Bool {
        return isExitOK
    }
}
