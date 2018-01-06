//
//  PersonRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth
import TNCore

protocol PersonRemoteService: class {
    
    func add(email: String, id: String, completion: @escaping (Result<String>) -> Void)
    func getProfile(of personID: String, completion: @escaping(Result<Person>) -> Void)
    func getMyProfile(completion: @escaping(Result<Person>) -> Void)
    func saveMyInfo(newValue: Person, oldValue: Person, completion: @escaping (Result<Person>) -> Void)
}

class PersonRemoteServiceProvider: PersonRemoteService {

    var personsQuery: PersonsRemoteQuery
    var personWriter: PersonRemoteWriter
    var meID: String
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider(), personWriter: PersonRemoteWriter = PersonRemoteWriterProvider()) {
        self.meID = meID
        self.personsQuery = personsQuery
        self.personWriter = personWriter
    }
    
    func add(email: String, id: String, completion: @escaping (Result<String>) -> Void) {
        personWriter.add(email: email, id: id) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok:
                completion(.ok("OK"))
            }
        }
    }
    
    func getProfile(of personID: String, completion: @escaping (Result<Person>) -> Void) {
        guard !personID.isEmpty else {
            completion(.err(Error("person ID is empty")))
            return
        }
        
        personsQuery.getPersons(for: [personID]) { persons in
            let persons = Array(Set(persons.filter({ $0.id == personID })))
            
            guard !persons.isEmpty else {
                completion(.err(Error("person not found")))
                return
            }
            
            completion(.ok(persons[0]))
        }
    }
    
    func getMyProfile(completion: @escaping (Result<Person>) -> Void) {
        getProfile(of: meID, completion: completion)
    }
    
    func saveMyInfo(newValue: Person, oldValue: Person, completion: @escaping (Result<Person>) -> Void) {
        guard !meID.isEmpty else {
            completion(.err(Error("current user ID is empty")))
            return
        }
        
        guard oldValue.id == meID else {
            completion(.err(Error("old personal info is not yours")))
            return
        }
        
        guard newValue.id == meID else {
            completion(.err(Error("new personal info is not yours")))
            return
        }
        
        if newValue.displayName.isEmpty, newValue.name.isEmpty {
            completion(.err(Error("chika name and display name are empty")))
            return
        }
        
        if newValue.displayName.isEmpty {
            completion(.err(Error("display name is empty")))
            return
        }
        
        if newValue.displayName.isEmpty {
            completion(.err(Error("chika name is empty")))
            return
        }
        
        personWriter.saveInfo(newValue: newValue, oldValue: oldValue) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok:
                completion(.ok(newValue))
            }            
        }
    }
}
