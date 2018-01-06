//
//  PasswordChangeSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol PasswordChangeSceneWorker: class {

    func changePassword(withNew newPassword: String, currentPassword: String, currentEmail: String)
}

protocol PasswordChangeSceneWorkerOutput: class {

    func workerDidChangePassword()
    func workerDidChangePasswordWithError(_ error: Swift.Error)
}

extension PasswordChangeScene {
    
    class Worker: PasswordChangeSceneWorker {
    
        weak var output: PasswordChangeSceneWorkerOutput?
        var service: AuthRemoteService
        
        init(service: AuthRemoteService = AuthRemoteServiceProvider()) {
            self.service = service
        }
        
        func changePassword(withNew newPassword: String, currentPassword: String, currentEmail: String) {
            service.changePassword(withNew: newPassword, currentPassword: currentPassword, currentEmail: currentEmail) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidChangePasswordWithError(info)
                
                case .ok:
                    self?.output?.workerDidChangePassword()
                }
            }
        }
    }
}
