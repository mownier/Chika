//
//  UserMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Firebase

class UserMock: User {
    
    let mockID: String
    let mockEmail: String?
    let mockRefreshToken: String?
    
    var isFirebaseAccessTokenEmpty: Bool
    var isFirebaseAccessTokenNil: Bool
    var isFirebaseAccessTokenError: Bool
    
    override var uid: String {
        return mockID
    }
    
    override var email: String? {
        return mockEmail
    }
    
    override var refreshToken: String? {
        return mockRefreshToken
    }
    
    init(uid: String, email: String? = nil, refreshToken: String? = nil) {
        self.mockID = uid
        self.mockEmail = email
        self.mockRefreshToken = refreshToken
        self.isFirebaseAccessTokenEmpty = false
        self.isFirebaseAccessTokenNil = false
        self.isFirebaseAccessTokenError = false
    }
    
    override func getIDTokenForcingRefresh(_ forceRefresh: Bool, completion: AuthTokenCallback? = nil) {
        guard !isFirebaseAccessTokenError else {
            let info = [NSLocalizedDescriptionKey: "Firebase access token interal localized error message"]
            let error = NSError(domain: "", code: 1, userInfo: info)
            completion?(nil, error)
            return
        }
        
        guard isFirebaseAccessTokenEmpty || isFirebaseAccessTokenNil else {
            completion?("accessToken", nil)
            return
        }
        
        if isFirebaseAccessTokenNil {
            completion?(nil, nil)
            return
        }
        
        if isFirebaseAccessTokenEmpty {
            completion?("", nil)
            return
        }
    }
}
