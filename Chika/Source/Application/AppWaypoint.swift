//
//  AppWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/17/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AppEntryWaypoint: class {
    
    func enter(from parent: UIViewController) -> Bool
}

protocol AppExitWaypoint: class {
    
    func exit() -> Bool
}
