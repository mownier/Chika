//
//  Message.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

struct Message {

    var id: String
    var date: Date
    var content: String
    var author: Person
    
    init() {
        id = ""
        date = Date()
        content = ""
        author = Person()
    }
}
