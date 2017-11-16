//
//  AuthRemoteServiceMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

@testable import Chika

class AuthRemoteServiceMock: AuthRemoteService {

    var isOK: Bool
    
    init() {
        self.isOK = true
    }
    
    func register(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void) {
        
    }
    
    func signIn(email: String, pass: String, completion: @escaping (ServiceResult<Access>) -> Void) {
        guard isOK else {
            completion(.err(ServiceError("Auth remote service forced error")))
            return
        }
        
        let access = Access(token: "accessToken", userID: "userID", email: "me@me.com", refreshToken: "refreshToken")
        completion(.ok(access))
    }
    
    func signOut(completion: @escaping (ServiceResult<String>) -> Void) {
        
    }
    
    func refresh(completion: @escaping (ServiceResult<Access>) -> Void) {
        
    }
}
