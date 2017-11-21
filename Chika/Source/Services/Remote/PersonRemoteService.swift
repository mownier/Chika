//
//  PersonRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol PersonRemoteService: class {
    
    func add(email: String, id: String, completion: @escaping (ServiceResult<String>) -> Void)
}

class PersonRemoteServiceProvider: PersonRemoteService {

    var database: Database
    
    init(database: Database = Database.database()) {
        self.database = database
    }
    
    func add(email: String, id: String, completion: @escaping (ServiceResult<String>) -> Void) {
        let ref = database.reference()
        let values = ["persons/\(id)": ["email": email, "id": id]]
        ref.updateChildValues(values) { error, _ in
            guard error == nil else {
                completion(.err(error!))
                return
            }
            
            completion(.ok("OK"))
        }
    }
}
