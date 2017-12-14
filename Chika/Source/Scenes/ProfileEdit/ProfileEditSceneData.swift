//
//  ProfileEditSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ProfileEditSceneData: class {

    var me: Person { set get }
}

extension ProfileEditScene {
    
    class Data: ProfileEditSceneData {
    
        var me: Person
    
        init() {
            me = Person()
        }
    }
}
