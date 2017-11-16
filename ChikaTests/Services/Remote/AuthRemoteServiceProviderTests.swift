//
//  AuthRemoteServiceProviderTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class AuthRemoteServiceProviderTests: XCTestCase {
    
    // CONTEXT: Instance of provider's auth must be the samez
    // with the instance of AuthMock
    func testInitA() {
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        XCTAssertTrue(auth == provider.auth)
    }
    
    // CONTEXT: Register function should return Firebase-defined error
    func testRegisterA() {
        let exp = expectation(description: "testRegisterA")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseInternalError = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
            
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "Firebase interal localized error message")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function should return an error that
    // user is nil
    func testRegisterB() {
        let exp = expectation(description: "testRegisterB")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseUserNil = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "user is nil")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function should return an error that
    // user has no ID
    func testRegisterC() {
        let exp = expectation(description: "testRegisterC")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseUserIDEmpty = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "user has no ID")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function has an empty email and it
    // should return an error that user has no email
    func testRegisterD() {
        let exp = expectation(description: "testRegisterD")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseUserEmailEmpty = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "user has no email")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function has a nil email and it
    // should return an error that user has no email
    func testRegisterE() {
        let exp = expectation(description: "testRegisterE")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseUserEmailNil = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "user has no email")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function has an empty access token and
    // it should return an error that there is no access token
    func testRegisterF() {
        let exp = expectation(description: "testRegisterF")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseAccessTokenEmpty = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "no access token")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function has a nil access token and
    // it should return an error that there is no access token
    func testRegisterG() {
        let exp = expectation(description: "testRegisterG")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseAccessTokenNil = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "no access token")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }

    // CONTEXT: Register function should return an Access struct
    func testRegisterH() {
        let exp = expectation(description: "testRegisterH")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .err:
                XCTFail()
            
            case .ok(let access):
                XCTAssertEqual(access.email, "me@me.com")
                XCTAssertEqual(access.userID, "userID")
                XCTAssertEqual(access.token, "accessToken")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }

    // CONTEXT: Register function has a nil refresh token and it
    // should return an error that there is no refresh token
    func testRegisterI() {
        let exp = expectation(description: "testRegisterI")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseRefreshTokenNil = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "no refresh token")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function has an empty refresh token and it
    // should return an error that there is no refresh token
    func testRegisterJ() {
        let exp = expectation(description: "testRegisterJ")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseRefreshTokenEmpty = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "no refresh token")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }

    // CONTEXT: Register function should return a Firebase-defined
    // error while retrieving access token
    func testRegisterK() {
        let exp = expectation(description: "testRegisterK")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseAccessTokenError = true
        
        provider.register(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .ok:
                XCTFail()
                
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "Firebase access token interal localized error message")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Sign in function should return an Access struct
    func testLoginA() {
        let exp = expectation(description: "testLoginA")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        provider.signIn(email: "me@me.com", pass: "12345") { result in
            switch result {
            case .err:
                XCTFail()
            
            case .ok(let access):
                XCTAssertEqual(access.email, "me@me.com")
                XCTAssertEqual(access.userID, "userID")
                XCTAssertEqual(access.token, "accessToken")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Refresh function should return an Access struct
    func testRefreshA() {
        let exp = expectation(description: "testRefreshA")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseUserMocked = true
        
        provider.refresh { result in
            switch result {
            case .err:
                XCTFail()
                
            case .ok(let access):
                XCTAssertEqual(access.email, "me@me.com")
                XCTAssertEqual(access.userID, "userID")
                XCTAssertEqual(access.token, "accessToken")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Sign out function should return error
    // that is unable to logout
    func testSignOutA() {
        let exp = expectation(description: "testSignOutA")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        auth.isFirebaseSignOutError = true
        
        provider.signOut { result in
            switch result {
            case .ok:
                XCTFail()
            
            case .err(let info):
                XCTAssertTrue(info is ServiceError)
                let msg = (info as! ServiceError).message
                XCTAssertEqual(msg, "unable to sign out")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Sign out function should return an 'OK' string
    func testSignOutB() {
        let exp = expectation(description: "testSignOutB")
        let auth = AuthMock(id: 0)
        let provider = AuthRemoteServiceProvider(auth: auth)
        
        provider.signOut { result in
            switch result {
            case .err:
                XCTFail()
                
            case .ok(let info):
                XCTAssertEqual(info, "OK")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
}
