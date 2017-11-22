//
//  PersonsRemoteQuery.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/21/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol PersonsRemoteQuery: class {
    
    func getPersons(for keys: [String], completion: @escaping ([Person]) -> Void)
}

protocol PersonsSort: class {
    
    func by(_ keys: [String], _ persons: inout [Person])
}

class PersonsRemoteQueryProvider: PersonsRemoteQuery {
    
    class Sort: PersonsSort {
        
        func by(_ keys: [String], _ persons: inout [Person]) {
            persons.sort { person1, person2 -> Bool in
                guard let index1 = keys.index(of: person1.id),
                    let index2 = keys.index(of: person2.id) else {
                        return false
                }
                
                return index1 < index2
            }
        }
    }
    
    var database: Database
    var path: String
    var sort: PersonsSort
    
    init(database: Database = Database.database(), path: String = "persons", sort: PersonsSort = Sort()) {
        self.database = database
        self.path = path
        self.sort = sort
    }
    
    func getPersons(for keys: [String], completion: @escaping ([Person]) -> Void) {
        guard !keys.isEmpty else {
            completion([])
            return
        }
        
        let rootRef = database.reference()
        
        var persons = [Person]()
        var personCounter: UInt = 0 {
            didSet {
                guard personCounter == keys.count else {
                    return
                }
                
                sort.by(keys, &persons)
                completion(persons)
            }
        }
        
        for key in keys {
            let ref = rootRef.child("\(path)/\(key)")
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let info = snapshot.value as? [String: Any] else {
                    personCounter += 1
                    return
                }
                
                var person = Person()
                person.id = info["id"] as? String ?? ""
                person.name = info["name"] as? String ?? ""
                person.avatarURL = info["avatar_url"] as? String ?? ""
                person.isOnline = info["is_online"] as? Bool ?? false
                
                persons.append(person)
                personCounter += 1
            }
        }
    }
}
