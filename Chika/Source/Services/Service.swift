//
//  Service.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

enum ServiceResult<T> {
    
    case ok(T)
    case err(Error)
}

struct ServiceError: Error {

    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension ServiceError: CustomStringConvertible {
    
    var description: String {
        return "SERVICE_ERR: \(message)"
    }
}

