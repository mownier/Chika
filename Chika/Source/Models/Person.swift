//
//  Person.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

struct Person {

    var id: String
    var name: String
    var avatarURL: String
    var isOnline: Bool
    
    init() {
        id = ""
        name = ""
        avatarURL = ""
        isOnline = false
    }
}

class PersonQuery {
    
    var database: Database
    var path: String
    
    init(database: Database = Database.database(), path: String = "persons") {
        self.database = database
        self.path = path
    }
    
    func getValues(for keys: [String], completion: @escaping ([Person]) -> Void) {
        let rootRef = database.reference()
        
        var persons = [Person]()
        var personCounter: UInt = 0 {
            didSet {
                guard personCounter == keys.count else {
                    return
                }
                
                guard !persons.isEmpty else {
                    completion([])
                    return
                }
                
                completion(persons)
            }
        }
        
        for key in keys {
            let ref = rootRef.child("\(path)/\(key)")
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let info = snapshot.value as? [String: Any] else {
                    completion([])
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
