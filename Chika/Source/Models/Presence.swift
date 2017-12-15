//
//  Presence.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct Presence {

    var activeOn: Double
    var isActive: Bool
    var personID: String
    
    init() {
        self.activeOn = 0
        self.isActive = false
        self.personID = ""
    }
}
