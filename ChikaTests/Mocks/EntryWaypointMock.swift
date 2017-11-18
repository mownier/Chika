//
//  EntryWaypointMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
@testable import Chika

class EntryWaypointMock: AppEntryWaypoint {

    var isEnterOK: Bool = false
    
    func enter(from parent: UIViewController) -> Bool {
        return isEnterOK
    }
}
