//
//  SignInSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import TNCore

protocol SignInSceneWorker: class {
    
    func signIn(email: String?, pass: String?)
}

protocol SignInSceneWorkerOutput: class {
    
    func workerDidSignInOK()
    func workerDidSignInWithError(_ error: Swift.Error)
}

extension SignInScene {
    
    class Worker: SignInSceneWorker {
        
        let service: AuthRemoteService
        weak var output: SignInSceneWorkerOutput?
        
        init(service: AuthRemoteService = AuthRemoteServiceProvider()) {
            self.service = service
        }
        
        func signIn(email: String?, pass: String?) {
            guard email != nil, pass != nil else {
                output?.workerDidSignInWithError(Error("email and pass must not be empty"))
                return
            }
            
            service.signIn(email: email!, pass: pass!) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSignInWithError(info)
                
                case .ok:
                    self?.output?.workerDidSignInOK()
                }
            }
        }
    }
}
