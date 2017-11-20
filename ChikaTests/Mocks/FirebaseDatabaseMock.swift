//
//  FirebaseDatabaseMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
@testable import Chika

class FirebaseDatabaseMock: Database {

    var mockReference: FirebaseDatabaseRefMock
    
    init(mockReference: FirebaseDatabaseRefMock = FirebaseDatabaseRefMock()) {
        self.mockReference = mockReference
        super.init()
    }
    
    override func reference() -> DatabaseReference {
        return mockReference
    }
}

class FirebaseDatabaseRefMock: DatabaseReference {
    
    var isOK: Bool
    
    override init() {
        self.isOK = true
        super.init()
    }
    
    override func updateChildValues(_ values: [AnyHashable : Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        guard isOK else {
            block(ServiceError("forced error"), self)
            return
        }
        
        block(nil, self)
    }
}
