//
//  HomeSceneFlowMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class HomeSceneFlowMock: HomeSceneFlow {

    var isConnected: Bool = false
    
    func connect(from scene: UIViewController) -> Bool {
        isConnected = true
        return true
    }
}
