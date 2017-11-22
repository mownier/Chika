//
//  PersonsSortMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PersonsSortMock: PersonsSort {

    var mockPersons: [Person] = []
    
    func by(_ keys: [String], _ persons: inout [Person]) {
        persons = mockPersons
    }
}
