//
//  AppError.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct AppError: Error {
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension AppError: CustomStringConvertible {
    
    var description: String {
        return "APP_ERR: \(message)"
    }
}
