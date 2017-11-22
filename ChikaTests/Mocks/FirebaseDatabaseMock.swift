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
    var query: FirebaseDatabaseQueryMock
    var childPath: String?
    var observerEventType: DataEventType?
    var snapshotValues: [Any?] = []
    
    override init() {
        self.isOK = true
        self.query = FirebaseDatabaseQueryMock()
        super.init()
    }
    
    override func updateChildValues(_ values: [AnyHashable : Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        guard isOK else {
            block(ServiceError("forced error"), self)
            return
        }
        
        block(nil, self)
    }
    
    override func queryOrdered(byChild key: String) -> DatabaseQuery {
        query.orderByChildKey = key
        return query
    }
    
    override func child(_ pathString: String) -> DatabaseReference {
        childPath = pathString
        return self
    }
    
    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
        observerEventType = eventType
        let snapshot = FirebaseDataSnapshot(value: snapshotValues.removeFirst())
        block(snapshot)
    }
}

class FirebaseDatabaseQueryMock: DatabaseQuery {
 
    var orderByChildKey: String = ""
    var limitToLast: UInt = 0
    var observerEventType: DataEventType?
    var snapshotValue: Any?
    
    override init() {
        super.init()
    }
    
    override func queryLimited(toLast limit: UInt) -> DatabaseQuery {
        limitToLast = limit
        return self
    }
    
    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
        observerEventType = eventType
        let snapshot = FirebaseDataSnapshot(value: snapshotValue)
        block(snapshot)
    }
}

class FirebaseDataSnapshot: DataSnapshot {
    
    var val: Any?
    
    override var value: Any? {
        return val
    }
    
    init(value: Any?) {
        self.val = value
    }
}
