//
//  PersonRemoteServiceMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class PersonRemoteServiceMock: PersonRemoteService {

    var isOK: Bool = true
    
    func add(email: String, id: String, completion: @escaping (ServiceResult<String>) -> Void) {
        if isOK {
            completion(.ok("OK"))
        
        } else {
            completion(.err(ServiceError("Person Remote Service Error")))
        }
    }
}
