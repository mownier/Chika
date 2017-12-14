//
//  EmailUpdateSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol EmailUpdateSceneData: class {

    var email: String { set get }
}

extension EmailUpdateScene {
    
    class Data: EmailUpdateSceneData {
    
        var email: String
        
        init() {
            self.email = ""
        }
    }
}
