//
//  PersonsRemoteQueryProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class PersonsRemoteQueryProviderTests: XCTestCase {
    
    // CONTEXT: getPersons function should return an empty array
    // GIVEN:
    //   - keys is empty
    func testGetPersonsA() {
        let exp = expectation(description: "testGetPersonsA")
        let query = PersonsRemoteQueryProvider()
        let keys = [String]()
        query.getPersons(for: keys) { persons in
            XCTAssertTrue(persons.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getPersons function should
    //   - return an array of person whose ids are not equal
    //     to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is not of type [String : Any]
    func testGetPersonsB() {
        let exp = expectation(description: "testGetPersonsB")
        let database = FirebaseDatabaseMock()
        let query = PersonsRemoteQueryProvider(database: database)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : 1, "name": 1.0]
        let snapshot2 = [Any]()
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getPersons(for: keys) { persons in
            XCTAssertEqual(persons.count, 1)
            XCTAssertNotEqual(keys, persons.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getPersons function should
    //   - return an array of persons whose ids are equal
    //     to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is of type [String : Any]
    func testGetPersonsC() {
        let exp = expectation(description: "testGetPersonsC")
        let database = FirebaseDatabaseMock()
        let query = PersonsRemoteQueryProvider(database: database)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "name": "name 1"]
        let snapshot2: [String : Any] = ["id" : "key:2", "name": "name 2"]
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getPersons(for: keys) { persons in
            XCTAssertEqual(persons.count, 2)
            XCTAssertEqual(keys, persons.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: getPersons function should
    //   - return an array of persons whose ids are not
    //     equal to the keys passed to the function
    // GIVEN:
    //   - keys is not empty
    //   - keys has 2 items
    //   - key:1 snapshot value is of type [String : Any]
    //   - key:2 snapshot value is of type [String : Any]
    //   - sort sorts incorrectly
    func testGetPersonsD() {
        let exp = expectation(description: "testGetPersonsD")
        let sort = PersonsSortMock()
        let database = FirebaseDatabaseMock()
        let query = PersonsRemoteQueryProvider(database: database, sort: sort)
        let keys = ["key:1", "key:2"]
        let snapshot1: [String : Any] = ["id" : "key:1", "name": "name 1"]
        let snapshot2: [String : Any] = ["id" : "key:2", "name": "name 2"]
        var person1 = Person()
        var person2 = Person()
        person1.id = "key:1"
        person2.id = "key:2"
        sort.mockPersons = [person2, person1]
        database.mockReference.snapshotValues = [snapshot1, snapshot2]
        query.getPersons(for: keys) { persons in
            XCTAssertEqual(persons.count, 2)
            XCTAssertNotEqual(keys, persons.map({ $0.id }))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
