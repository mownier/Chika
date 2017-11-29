//
//  Person.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

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

extension Person: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}
