//
//  PersonRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol PersonRemoteService: class {
    
    func add(email: String, id: String, completion: @escaping (ServiceResult<String>) -> Void)
    func getProfile(of personID: String, completion: @escaping(ServiceResult<Person>) -> Void)
    func getMyProfile(completion: @escaping(ServiceResult<Person>) -> Void)
}

class PersonRemoteServiceProvider: PersonRemoteService {

    var database: Database
    var personsQuery: PersonsRemoteQuery
    var meID: String
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
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
    
    func getProfile(of personID: String, completion: @escaping (ServiceResult<Person>) -> Void) {
        guard !personID.isEmpty else {
            completion(.err(ServiceError("person ID is empty")))
            return
        }
        
        personsQuery.getPersons(for: [personID]) { persons in
            let persons = Array(Set(persons.filter({ $0.id == personID })))
            
            guard !persons.isEmpty else {
                completion(.err(ServiceError("person not found")))
                return
            }
            
            completion(.ok(persons[0]))
        }
    }
    
    func getMyProfile(completion: @escaping (ServiceResult<Person>) -> Void) {
        getProfile(of: meID, completion: completion)
    }
}
