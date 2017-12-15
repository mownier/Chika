//
//  Person.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct Person {

    private var dispName: String = ""
    
    var id: String
    var name: String
    var avatarURL: String
    var displayName: String {
        set {
            dispName = newValue
        }
        get {
            if dispName.isEmpty {
                return name
            }
            return dispName
        }
    }
    
    var email: String
    
    init() {
        id = ""
        name = ""
        avatarURL = ""
        email = ""
        self.displayName = ""
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

struct Contact {
    
    var person: Person
    var chat: Chat
    
    init() {
        person = Person()
        chat = Chat()
    }
    
    struct Request {
        
        var id: String
        var requestee: Person
        var message: String
        var createdOn: Double
        
        init() {
            self.id = ""
            self.message = ""
            self.requestee = Person()
            self.createdOn = 0
        }
    }
}

struct PersonSearchObject: Hashable {
    
    var person: Person
    var chat: Chat
    var isContact: Bool
    var isRequested: Bool
    var isPending: Bool
    
    init() {
        person = Person()
        chat = Chat()
        isContact = false
        isRequested = false
        isPending = false
    }
    
    var hashValue: Int {
        return person.hashValue
    }
    
    static func ==(lhs: PersonSearchObject, rhs: PersonSearchObject) -> Bool {
        return lhs.person == rhs.person && lhs.chat.id == rhs.chat.id && lhs.isContact == rhs.isContact && lhs.isRequested == rhs.isRequested
    }
}
