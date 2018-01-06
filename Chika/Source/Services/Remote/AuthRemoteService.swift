//
//  AuthRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth
import TNCore

protocol AuthRemoteService: class {
    
    func register(email: String, pass: String, completion: @escaping (Result<Access>) -> Void)
    func signIn(email: String, pass: String, completion: @escaping (Result<Access>) -> Void)
    func signOut(completion: @escaping (Result<String>) -> Void)
    func refresh(completion: @escaping (Result<Access>) -> Void)
    func changeEmail(withNew: String, currentEmail: String, currentPassword: String, completion: @escaping (Result<String>) -> Void)
    func changePassword(withNew: String, currentPassword: String, currentEmail: String, completion: @escaping (Result<String>) -> Void)
}

class AuthRemoteServiceProvider: AuthRemoteService {

    var auth: Auth
    var presenceWriterFactory: PresenceRemoteWriterFactory
    
    init(auth: Auth = Auth.auth(), presenceWriterFactory: PresenceRemoteWriterFactory = PresenceRemoteWriterProvider.Factory()) {
        self.auth = auth
        self.presenceWriterFactory = presenceWriterFactory
    }
    
    func register(email: String, pass: String, completion: @escaping (Result<Access>) -> Void) {
        auth.createUser(withEmail: email, password: pass) { [weak self] user, error in
            self?.handleAccessResult(user, error) { result in
                self?.handleMakeOnline(result, completion)
            }
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Result<Access>) -> Void) {
        auth.signIn(withEmail: email, password: pass) { [weak self] user, error in
            self?.handleAccessResult(user, error) { result in
                self?.handleMakeOnline(result, completion)
            }
        }
    }
    
    func signOut(completion: @escaping (Result<String>) -> Void) {
        let writer = presenceWriterFactory.build()
        writer.makeOffline { [weak self] result in
            switch result {
            case .err(let info):
                completion(.err(info))
            
            case .ok:
                do {
                    try self?.auth.signOut()
                    completion(.ok("OK"))
                    
                } catch {
                    completion(.err(Error("unable to sign out")))
                }
            }
        }
    }
    
    func refresh(completion: @escaping (Result<Access>) -> Void) {
        handleAccessResult(auth.currentUser, nil, completion)
    }
    
    func changeEmail(withNew newEmail: String, currentEmail: String, currentPassword: String, completion: @escaping (Result<String>) -> Void) {
        guard let user = auth.currentUser, let userEmail = user.email, !userEmail.isEmpty else {
            completion(.err(Error("no current user")))
            return
        }
        
        guard !currentEmail.isEmpty else {
            completion(.err(Error("provided current email is empty")))
            return
        }
        
        guard currentEmail == userEmail else {
            completion(.err(Error("provided current email is not the same with the current user's email")))
            return
        }
        
        guard !currentPassword.isEmpty else {
            completion(.err(Error("provided current password is empty")))
            return
        }
        
        guard currentEmail != newEmail else {
            completion(.err(Error("provided new and current emails are the same")))
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
    
    func changePassword(withNew newPassword: String, currentPassword: String, currentEmail: String, completion: @escaping (Result<String>) -> Void) {
        guard let user = auth.currentUser, let userEmail = user.email, !userEmail.isEmpty else {
            completion(.err(Error("no current user")))
            return
        }
        
        guard currentEmail == userEmail else {
            completion(.err(Error("provided current email is not the same with the current user's email")))
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
    
    private func handleAccessResult(_ user: User?, _ error: Swift.Error?, _ completion: @escaping (Result<Access>) -> Void) {
        guard error == nil else {
            completion(.err(Error("\(error!.localizedDescription)")))
            return
        }
        
        guard let user = user else {
            completion(.err(Error("user is nil")))
            return
        }
        
        guard !user.uid.isEmpty else {
            completion(.err(Error("user has no ID")))
            return
        }
        
        guard let email = user.email, !email.isEmpty else {
            completion(.err(Error("user has no email")))
            return
        }
        
        guard let refreshToken = user.refreshToken, !refreshToken.isEmpty else {
            completion(.err(Error("no refresh token")))
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
    
    private func getAccess(_ user: User, _ completion: @escaping (Result<String>) -> Void) {
        user.getIDTokenForcingRefresh(true) { token, error in
            guard error == nil else {
                completion(.err(Error("\(error!.localizedDescription)")))
                return
            }
            
            guard let token = token, !token.isEmpty else {
                completion(.err(Error("no access token")))
                return
            }
            
            completion(.ok(token))
        }
    }
    
    private func handleMakeOnline(_ result: Result<Access>, _ completion: @escaping (Result<Access>) -> Void) {
        switch result {
        case .err:
            completion(result)
            
        case .ok(let access):
            let writer = presenceWriterFactory.build()
            writer.makeOnline { [weak self] result in
                switch result {
                case .err(let info):
                    try? self?.auth.signOut()
                    completion(.err(info))
                    
                case .ok:
                    completion(.ok(access))
                }
            }
        }
    }
}
