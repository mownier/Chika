//
//  RemoteWriterResult.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/25/17.
//  Copyright © 2017 Nir. All rights reserved.
//

enum RemoteWriterResult<T> {

    case ok(T)
    case err(Error)
}

struct RemoteWriterError: Error {
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension RemoteWriterError: CustomStringConvertible {
    
    var description: String {
        return "REMOTE_WRITER_ERR: \(message)"
    }
}
