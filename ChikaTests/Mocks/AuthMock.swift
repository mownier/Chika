//
//  AuthMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import Firebase
@testable import Chika

class AuthMock: Auth {

    var id: Int
    var isFirebaseInternalError: Bool
    var isFirebaseUserNil: Bool
    var isFirebaseUserIDEmpty: Bool
    var isFirebaseUserEmailEmpty: Bool
    var isFirebaseUserEmailNil: Bool
    var isFirebaseAccessTokenEmpty: Bool
    var isFirebaseAccessTokenNil: Bool
    var isFirebaseRefreshTokenEmpty: Bool
    var isFirebaseRefreshTokenNil: Bool
    var isFirebaseAccessTokenError: Bool
    var isFirebaseUserMocked: Bool
    var isFirebaseSignOutError: Bool
    
    override var currentUser: User? {
        guard isFirebaseUserMocked else {
            return nil
        }
        
        let user = UserMock(uid: "userID", email: "me@me.com", refreshToken: "refreshToken")
        return user
    }
    
    init(id: Int) {
        self.id = id
        self.isFirebaseInternalError = false
        self.isFirebaseUserNil = false
        self.isFirebaseUserIDEmpty = false
        self.isFirebaseUserEmailEmpty = false
        self.isFirebaseUserEmailNil = false
        self.isFirebaseAccessTokenEmpty = false
        self.isFirebaseAccessTokenNil = false
        self.isFirebaseRefreshTokenNil = false
        self.isFirebaseRefreshTokenEmpty = false
        self.isFirebaseAccessTokenError = false
        self.isFirebaseUserMocked = false
        self.isFirebaseSignOutError = false
    }
    
    override func signIn(withEmail email: String, password pass: String, completion: ((User?, Error?) -> Void)?) {
        let user = UserMock(uid: "userID", email: "me@me.com", refreshToken: "refreshToken")
        completion?(user, nil)
    }
    
    override func createUser(withEmail email: String, password pass: String, completion: ((User?, Error?) -> Void)?) {
        guard !isFirebaseInternalError else {
            let info = [NSLocalizedDescriptionKey: "Firebase interal localized error message"]
            let error = NSError(domain: "", code: 1, userInfo: info)
            completion?(nil, error)
            return
        }
        
        guard !isFirebaseUserNil else {
            completion?(nil, nil)
            return
        }
        
        guard !isFirebaseUserIDEmpty else {
            completion?(UserMock(uid: ""), nil)
            return
        }
        
        guard !isFirebaseUserEmailNil else {
            let user = UserMock(uid: "userID", email: nil)
            completion?(user, nil)
            return
        }
        
        guard !isFirebaseUserEmailEmpty else {
            let user = UserMock(uid: "userID", email: "")
            completion?(user, nil)
            return
        }
        
        guard !isFirebaseRefreshTokenNil else {
            let user = UserMock(uid: "userID", email: "me@me.com", refreshToken: nil)
            completion?(user, nil)
            return
        }
        
        guard !isFirebaseRefreshTokenEmpty else {
            let user = UserMock(uid: "userID", email: "me@me.com", refreshToken: "")
            completion?(user, nil)
            return
        }
        
        let user = UserMock(uid: "userID", email: "me@me.com", refreshToken: "refreshToken")
        user.isFirebaseAccessTokenEmpty = isFirebaseAccessTokenEmpty
        user.isFirebaseAccessTokenNil = isFirebaseAccessTokenNil
        user.isFirebaseAccessTokenError = isFirebaseAccessTokenError
        completion?(user, nil)
    }
    
    override func signOut() throws {
        guard !isFirebaseSignOutError else {
            let info = [NSLocalizedDescriptionKey: "Firebase sign out error"]
            throw NSError(domain: "com.Firebase", code: 0, userInfo: info)
        }
        
        return
    }
}
