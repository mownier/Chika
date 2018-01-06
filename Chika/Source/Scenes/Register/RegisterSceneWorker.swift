//
//  RegisterSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import TNCore

protocol RegisterSceneWorker: class {
    
    func register(email: String?, pass: String?)
}

protocol RegisterSceneWorkerOutput: class {
    
    func workerDidRegisterOK()
    func workerDidRegisterWithError(_ error: Swift.Error)
}

extension RegisterScene {
    
    class Worker: RegisterSceneWorker {
        
        struct Service {
            
            var auth: AuthRemoteService
            var person: PersonRemoteService
        }
        
        weak var output: RegisterSceneWorkerOutput?
        var service: Service
        
        init(service: Service) {
            self.service = service
        }
        
        convenience init() {
            let person = PersonRemoteServiceProvider()
            let auth = AuthRemoteServiceProvider()
            let service = Service(auth: auth, person: person)
            self.init(service: service)
        }
        
        func register(email: String?, pass: String?) {
            guard email != nil, pass != nil else {
                let error = Error("email and pass must not be empty")
                output?.workerDidRegisterWithError(error)
                return
            }
            
            service.auth.register(email: email!, pass: pass!) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidRegisterWithError(info)
                    
                case .ok(let access):
                    self?.service.person.add(email: access.email, id: access.userID) { result in
                        switch result {
                        case .err(let info):
                            self?.output?.workerDidRegisterWithError(info)
                            
                        case .ok:
                            self?.output?.workerDidRegisterOK()
                        }
                    }
                }
            }
        }
    }
}
