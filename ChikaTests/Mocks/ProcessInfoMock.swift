//
//  ProcessInfoMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

class ProcessInfoMock: ProcessInfo {
    
    var mockArguments: [String] = []
    
    override var arguments: [String] {
        return mockArguments
    }
}
