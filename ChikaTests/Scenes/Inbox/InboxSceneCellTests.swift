//
//  InboxSceneCellTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class InboxSceneCellTests: XCTestCase {
    
    // CONTEXT: Convenience Constructor should have a reuseID
    // equivalent to "InboxSceneCell"
    func testInitA() {
        let cell = InboxSceneCell()
        XCTAssertEqual(cell.reuseIdentifier, "InboxSceneCell")
        
        let cell2 = InboxSceneCell(coder: NSCoder())!
        XCTAssertEqual(cell2.reuseIdentifier, "InboxSceneCell")
    }
}
