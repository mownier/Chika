//
//  PersonsRemoteQueryMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/22/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PersonsRemoteQueryMock: PersonsRemoteQuery {

    var mockPersons: [[Person]] = []
    
    func getPersons(for keys: [String], completion: @escaping ([Person]) -> Void) {
        completion(mockPersons.removeFirst())
    }
}
