//
//  ContactRequestsRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ContactRequestsRemoteQuery: class {

    func getSentRequests(callback: @escaping ([Contact.Request]) -> Void)
    func getPendingRequests(callback: @escaping ([Contact.Request]) -> Void)
}

class ContactRequestsRemoteQueryProvider: ContactRequestsRemoteQuery {
    
    private enum Request {
        
        case sent, pending
    }
    
    var meID: String
    var database: Database
    var personsQuery: PersonsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), personsQuery: PersonsRemoteQuery = PersonsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.personsQuery = personsQuery
    }
    
    func getSentRequests(callback: @escaping ([Contact.Request]) -> Void) {
       getRequests(.sent, callback: callback)
    }
    
    func getPendingRequests(callback: @escaping ([Contact.Request]) -> Void) {
       getRequests(.pending, callback: callback)
    }
    
    private func getRequests(_ type: Request, callback: @escaping ([Contact.Request]) -> Void) {
        let meID = self.meID
        guard !meID.isEmpty else {
            callback([])
            return
        }
        
        let queryChild: String
        switch type {
        case .sent: queryChild = "requestor"
        case .pending: queryChild = "requestee"
        }
        
        let personsQuery = self.personsQuery
        let rootRef = database.reference()
        let query = rootRef.child("person:contact:request:established/\(meID)").queryOrdered(byChild: queryChild).queryEqual(toValue: meID)
        query.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                callback([])
                return
            }
            
            var personKeys: [String] = []
            var values: [String: [String: Any]] = [:]
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot, !child.key.isEmpty,
                    let value = child.value as? [String: Any] else {
                        continue
                }
                
                values[child.key] = value
                personKeys.append(child.key)
            }
            
            personsQuery.getPersons(for: personKeys) { persons in
                let persons = Array(Set(persons)).filter({ personKeys.contains($0.id) && values[$0.id] != nil })
                
                guard !persons.isEmpty else {
                    callback([])
                    return
                }
                
                let requests = persons.map({ person -> Contact.Request in
                    let value = values[person.id]
                    var request = Contact.Request()
                    request.id = value?["id"] as? String ?? ""
                    request.message = value?["message"] as? String ?? ""
                    request.createdOn = value?["created:on"] as? Double ?? 0
                    
                    switch type {
                    case .sent: request.requestee = person
                    case .pending: request.requestor = person
                    }
                    
                    return request
                })
                
                callback(requests)
            }
        }
    }
}
