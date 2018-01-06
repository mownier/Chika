//
//  AuthRemoteServiceMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika
import TNCore

class AuthRemoteServiceMock: AuthRemoteService {

    var isOK: Bool
    
    init() {
        self.isOK = true
    }
    
    func register(email: String, pass: String, completion: @escaping (Result<Access>) -> Void) {
        guard isOK else {
            completion(.err(Error("Auth remote service forced error")))
            return
        }
        
        let access = Access(token: "accessToken", userID: "userID", email: "me@me.com", refreshToken: "refreshToken")
        completion(.ok(access))
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Result<Access>) -> Void) {
        guard isOK else {
            completion(.err(Error("Auth remote service forced error")))
            return
        }
        
        let access = Access(token: "accessToken", userID: "userID", email: "me@me.com", refreshToken: "refreshToken")
        completion(.ok(access))
    }
    
    func signOut(completion: @escaping (Result<String>) -> Void) {
        
    }
    
    func refresh(completion: @escaping (Result<Access>) -> Void) {
        
    }
    
    func changeEmail(withNew: String, currentEmail: String, currentPassword: String, completion: @escaping (Result<String>) -> Void) {
        
    }
    
    func changePassword(withNew: String, currentPassword: String, currentEmail: String, completion: @escaping (Result<String>) -> Void) {
        
    }
}
