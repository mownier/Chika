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
    func changeEmail(withNew: String, currentEmail: String, currentPassword: String, completion: @escaping (ServiceResult<String>) -> Void)
    func changePassword(withNew: String, currentPassword: String, currentEmail: String, completion: @escaping (ServiceResult<String>) -> Void)
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
    
    func changeEmail(withNew newEmail: String, currentEmail: String, currentPassword: String, completion: @escaping (ServiceResult<String>) -> Void) {
        guard let user = auth.currentUser, let userEmail = user.email, !userEmail.isEmpty else {
            completion(.err(ServiceError("no current user")))
            return
        }
        
        guard !currentEmail.isEmpty else {
            completion(.err(ServiceError("provided current email is empty")))
            return
        }
        
        guard currentEmail == userEmail else {
            completion(.err(ServiceError("provided current email is not the same with the current user's email")))
            return
        }
        
        guard !currentPassword.isEmpty else {
            completion(.err(ServiceError("provided current password is empty")))
            return
        }
        
        guard currentEmail != newEmail else {
            completion(.err(ServiceError("provided new and current emails are the same")))
            return
        }
        
        auth.signIn(withEmail: userEmail, password: currentPassword) { [weak self] user, error in
            self?.handleAccessResult(user, error, { result in
                switch result {
                case .err(let info):
                    completion(.err(info))
                
                case .ok:                    
                    user?.updateEmail(to: newEmail, completion: { error in
                        completion(.ok(newEmail))
                    })
                }
            })
        }
    }
    
    func changePassword(withNew newPassword: String, currentPassword: String, currentEmail: String, completion: @escaping (ServiceResult<String>) -> Void) {
        guard let user = auth.currentUser, let userEmail = user.email, !userEmail.isEmpty else {
            completion(.err(ServiceError("no current user")))
            return
        }
        
        guard currentEmail == userEmail else {
            completion(.err(ServiceError("provided current email is not the same with the current user's email")))
            return
        }
        
        auth.signIn(withEmail: userEmail, password: currentPassword) { [weak self] user, error in
            self?.handleAccessResult(user, error, { result in
                switch result {
                case .err(let info):
                    completion(.err(info))
                    
                case .ok:
                    user?.updatePassword(to: newPassword, completion: { error in
                        guard error == nil else {
                            completion(.err(error!))
                            return
                        }
                        
                        completion(.ok("OK"))
                    })
                }
            })
        }
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
