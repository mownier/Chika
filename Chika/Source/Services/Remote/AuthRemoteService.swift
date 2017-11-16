//
//  AuthRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol AuthRemoteService: class {
    
    func register(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void)
    func signIn(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void)
    func signOut(completion: @escaping (ServiceResult<String>) -> Void)
    func refresh(completion: @escaping (ServiceResult<Access>) -> Void)
}

class AuthRemoteServiceProvider: AuthRemoteService {

    var auth: Auth
    
    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }
    
    func register(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void) {
        auth.createUser(withEmail: email, password: pass) { [weak self] user, error in
           self?.handleAccessResult(user, error, completion)
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void) {
        auth.signIn(withEmail: email, password: pass) { [weak self] user, error in
            self?.handleAccessResult(user, error, completion)
        }
    }
    
    func signOut(completion: @escaping (ServiceResult<String>) -> Void) {
        do {
            try auth.signOut()
            completion(.ok("OK"))
            
        } catch {
            completion(.err(ServiceError("unable to sign out")))
        }
    }
    
    func refresh(completion: @escaping (ServiceResult<Access>) -> Void) {
        handleAccessResult(auth.currentUser, nil, completion)
    }
    
    private func handleAccessResult(_ user: User?, _ error: Error?, _ completion: @escaping (ServiceResult<Access>) -> Void) {
        guard error == nil else {
            completion(.err(ServiceError("\(error!.localizedDescription)")))
            return
        }
        
        guard let user = user else {
            completion(.err(ServiceError("user is nil")))
            return
        }
        
        guard !user.uid.isEmpty else {
            completion(.err(ServiceError("user has no ID")))
            return
        }
        
        guard let email = user.email, !email.isEmpty else {
            completion(.err(ServiceError("user has no email")))
            return
        }
        
        guard let refreshToken = user.refreshToken, !refreshToken.isEmpty else {
            completion(.err(ServiceError("no refresh token")))
            return
        }
        
        getAccess(user) { result in
            switch result {
            case .err(let info):
                completion(.err(info))
                
            case .ok(let token):
                let access = Access(token: token, userID: user.uid, email: email, refreshToken: refreshToken)
                completion(.ok(access))
            }
        }
    }
    
    private func getAccess(_ user: User, _ completion: @escaping (ServiceResult<String>) -> Void) {
        user.getIDTokenForcingRefresh(true) { token, error in
            guard error == nil else {
                completion(.err(ServiceError("\(error!.localizedDescription)")))
                return
            }
            
            guard let token = token, !token.isEmpty else {
                completion(.err(ServiceError("no access token")))
                return
            }
            
            completion(.ok(token))
        }
    }
}
