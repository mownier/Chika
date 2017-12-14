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
    func saveMyInfo(newValue: Person, oldValue: Person, completion: @escaping (ServiceResult<Person>) -> Void)
}

class PersonRemoteServiceProvider: PersonRemoteService {

    var database: Database
    var personsQuery: PersonsRemoteQuery
    var personWriter: PersonRemoteWriter
    var meID: String
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), personWriter: PersonRemoteWriter = PersonRemoteWriterProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
        self.personWriter = personWriter
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
    
    func saveMyInfo(newValue: Person, oldValue: Person, completion: @escaping (ServiceResult<Person>) -> Void) {
        guard !meID.isEmpty else {
            completion(.err(ServiceError("current user ID is empty")))
            return
        }
        
        guard oldValue.id == meID else {
            completion(.err(ServiceError("old personal info is not yours")))
            return
        }
        
        guard newValue.id == meID else {
            completion(.err(ServiceError("new personal info is not yours")))
            return
        }
        
        if newValue.displayName.isEmpty, newValue.name.isEmpty {
            completion(.err(ServiceError("chika name and display name are empty")))
            return
        }
        
        if newValue.displayName.isEmpty {
            completion(.err(ServiceError("display name is empty")))
            return
        }
        
        if newValue.displayName.isEmpty {
            completion(.err(ServiceError("chika name is empty")))
            return
        }
        
        personWriter.saveInfo(newValue: newValue, oldValue: oldValue) { error in
            guard error == nil else {
                completion(.err(error!))
                return
            }
            
            completion(.ok(newValue))
        }
    }
}
