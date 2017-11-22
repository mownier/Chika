//
//  PersonsRemoteQueryProviderSortTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class PersonsRemoteQueryProviderSortTests: XCTestCase {
    
    // CONTEXT: sortByKeys function should fail to sort
    // the array given that person ids are not found in keys
    func testSortByKeysA() {
        let sort = PersonsRemoteQueryProvider.Sort()
        let keys = ["key:1", "key:2", "key:3"]
        var person1 = Person()
        var person2 = Person()
        person1.id = "key:4"
        person2.id = "key:5"
        var persons = [person1, person2]
        let copy = persons
        sort.by(keys, &persons)
        XCTAssertEqual(copy.map({ $0.id }), persons.map({ $0.id }))
    }
    
    // CONTEXT: sortByKeys function should fail to sort
    // the persons according to the passed keys
    func testSortByKeysB() {
        let sort = PersonsRemoteQueryProvider.Sort()
        let keys = ["key:1", "key:2", "key:3"]
        var person1 = Person()
        var person2 = Person()
        var person3 = Person()
        person1.id = "key:1"
        person2.id = "key:2"
        person3.id = "key:3"
        var persons = [person2, person3, person1]
        let copy = persons
        sort.by(keys, &persons)
        XCTAssertNotEqual(copy.map({ $0.id }), persons.map({ $0.id }))
        XCTAssertEqual(keys, persons.map({ $0.id }))
    }
}
