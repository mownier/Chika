//
//  RemoteListenerResult.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/27/17.
//  Copyright © 2017 Nir. All rights reserved.
//

enum RemoteListenerResult<T> {
    
    case ok(T)
    case err(Error)
}

struct RemoteListenerError: Error {
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension RemoteListenerError: CustomStringConvertible {
    
    var description: String {
        return "REMOTE_LISTENER_ERR: \(message)"
    }
}
