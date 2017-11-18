//
//  SignInSceneWorkerTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class SignInSceneWorkerTests: XCTestCase {
    
    // CONTEXT: Initialize with default values of service and output
    func testInitA() {
        let worker = SignInScene.Worker()
        XCTAssertNil(worker.output)
        XCTAssertTrue(worker.service is AuthRemoteServiceProvider)
    }
    
    // CONTEXT: Sign in function has nil email and pass and it should
    // return with app error that email and pass must not be empty
    func testSignInA() {
        let exp = expectation(description: "testSignInA")
        let output = SignInSceneWorkerOutputMock(exp: exp)
        let worker = SignInScene.Worker()
        output.ok = { XCTFail() }
        output.err = { error in
            XCTAssertTrue(error is AppError)
            let msg = (error as! AppError).message
            XCTAssertEqual(msg, "email and pass must not be empty")
        }
        worker.output = output
        worker.signIn(email: nil, pass: nil)
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Sign in function should return error coming
    // from the service
    func testSignInB() {
        let exp = expectation(description: "testSignInB")
        let service = AuthRemoteServiceMock()
        let output = SignInSceneWorkerOutputMock(exp: exp)
        let worker = SignInScene.Worker(service: service)
        service.isOK = false
        output.ok = { XCTFail() }
        output.err =  { error in
            XCTAssertTrue(error is ServiceError)
            let msg = (error as! ServiceError).message
            XCTAssertEqual(msg, "Auth remote service forced error")
        }
        worker.output = output
        worker.signIn(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Sign in function should return ok from the service
    func testSignInC() {
        let exp = expectation(description: "testSignInC")
        let mockService = AuthRemoteServiceMock()
        let output = SignInSceneWorkerOutputMock(exp: exp)
        let worker = SignInScene.Worker(service: mockService)
        output.ok = { }
        output.err =  { _ in XCTFail() }
        worker.output = output
        worker.signIn(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
}
