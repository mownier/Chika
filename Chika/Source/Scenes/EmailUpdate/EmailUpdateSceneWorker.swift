//
//  EmailUpdateSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol EmailUpdateSceneWorker: class {

    func changeEmail(withNew new: String, currentEmail: String, currentPassword: String)
}

protocol EmailUpdateSceneWorkerOutput: class {

    func workerDidChangeEmail(_ email: String)
    func workerDidChangeEmailWithError(_ error: Swift.Error)
}

extension EmailUpdateScene {
    
    class Worker: EmailUpdateSceneWorker {
    
        weak var output: EmailUpdateSceneWorkerOutput?
        var service: AuthRemoteService
        
        init(service: AuthRemoteService = AuthRemoteServiceProvider()) {
            self.service = service
        }
        
        func changeEmail(withNew new: String, currentEmail: String, currentPassword: String) {
            service.changeEmail(withNew: new, currentEmail: currentEmail, currentPassword: currentPassword) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidChangeEmailWithError(info)
                
                case .ok(let newEmail):
                    self?.output?.workerDidChangeEmail(newEmail)
                }
            }
        }
    }
}
