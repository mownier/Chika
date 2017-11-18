//
//  RegisterSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol RegisterSceneWorker: class {
    
    func register(email: String?, pass: String?)
}

protocol RegisterSceneWorkerOutput: class {
    
    func workerDidRegisterOK()
    func workerDidRegisterWithError(_ error: Error)
}

extension RegisterScene {
    
    class Worker: RegisterSceneWorker {
        
        weak var output: RegisterSceneWorkerOutput?
        var service: AuthRemoteService
        
        init(service: AuthRemoteService = AuthRemoteServiceProvider()) {
            self.service = service
        }
        
        func register(email: String?, pass: String?) {
            guard email != nil, pass != nil else {
                let error = AppError("email and pass must not be empty")
                output?.workerDidRegisterWithError(error)
                return
            }
            
            service.register(email: email!, pass: pass!) { [weak self] result in
                switch result {
                case .ok:
                    self?.output?.workerDidRegisterOK()
                
                case .err(let info):
                    self?.output?.workerDidRegisterWithError(info)
                }
            }
        }
    }
}
